module Upwork
  module Crawler
    class Bot
      USER_AGENT = 'Mozilla/5.0 (Unknown; Linux) AppleWebKit/538.1 (KHTML, like Gecko) Chrome/v1.0.0 Safari/538.1'.freeze
      UPWORK_URL = 'https://www.upwork.com'.freeze
      UPWORK_LOGIN_URL = "#{UPWORK_URL}/ab/account-security/login".freeze
      STEPS = [
        :set_proxy,
        :get_xsft_token,
        :login!,
        :set_job,
        :fetch_opening_uid,
        :fetch_client
      ].freeze

      attr_reader :user
      attr_reader :running, :step
      attr_reader :proxy, :cookie, :xsrf_token
      attr_reader :job

      def initialize(user)
        @user = user
        @step = :set_proxy
      end

      def run!
        puts 'Run!'.green
        return nil if user.busy?
        user.busy!

        @running = true

        while running
          puts "Step: #{step}".green
          send(step) if STEPS.include?(step)
        end
      end

      private

      def set_proxy
        @proxy.free! if @proxy.present?
        @proxy = Upwork::Proxy.free_and_alive
        @proxy.busy!
        @step = :get_xsft_token
      end

      def get_xsft_token
        uri = URI.parse(UPWORK_LOGIN_URL)
        response = request(uri, configurate_base_request_with_headers(uri))

        if response.code == '403'
          @step = :set_proxy
          return
        end

        @cookie = parse_cookie(response)
        @xsrf_token = /XSRF-TOKEN=([^;]+)/.match(cookie).try(:[], 1)

        @step = :login!
      end

      def login!
        uri = URI.parse(UPWORK_LOGIN_URL)

        req = configurate_base_request_with_headers(URI.parse(UPWORK_LOGIN_URL), 'Post')
        req['Referer'] = UPWORK_LOGIN_URL
        req['X-Requested-With'] = 'XMLHttpRequest'
        req['X-Odesk-User-Agent'] = 'oDesk LM'
        req['X-Odesk-Csrf-Token'] = xsrf_token
        req.content_type = 'application/json;charset=UTF-8'

        req.body = JSON.dump({
          'login[username]' => user.email,
          'login[password]' => user.password,
          'login[mode]' => 'password'
        })

        response = request(uri, req)

        if response.code == '403'
          @step = :set_proxy
          return
        end

        @cookie = parse_cookie(response)

        @step = :set_job
      end

      def set_job
        @job = Upwork::Job.find_by(parsing_state: [:expecting_opening_uid])

        @running = false if job.nil?

        @step = :fetch_opening_uid
      end

      def fetch_opening_uid
        job.fetching_opening_uid!
        uri = URI.parse(@job.url.gsub(/^http:/, 'https:'))
        response = request(uri, configurate_base_request_with_headers(uri))

        if response.code == '403'
          if response.body['Access denied']
            job.set_parsing_error('Access denied', :error_fetching_opening_uid)
            @step = :set_job
            sleep 2
          elsif response.body['This is private job']
            job.set_parsing_error('Private job', :error_fetching_opening_uid)
            @step = :set_job
            sleep 2
          else
            binding.pry
          end
        else
          opening_uid = /openingUid',\s'(\d+)/.match(response.body).try(:[], 1)

          if opening_uid.present?
            job.update(opening_uid: opening_uid, parsing_state: :expecting_client_info)
            @step = :set_job
            sleep 2
            return
          end
        end
      end

      def request(uri, req)
        user.touch(:last_request_at)
        proxy.touch(:last_request_at)

        options = { use_ssl: uri.scheme == 'https' }

        Net::HTTP.start(uri.hostname, uri.port, proxy&.host, proxy&.port, options) do |http|
          http.request(req)
        end
      end

      def configurate_base_request_with_headers(uri, method = 'Get')
        req = "Net::HTTP::#{method}".constantize.new(uri)
        req['Cookie'] = cookie if step != :get_xsft_token
        req['Pragma'] = 'no-cache'
        req['Accept'] = 'text/html'
        req['Referer'] = 'https://www.upwork.com/'
        req['Authority'] = 'www.upwork.com'
        req['User-Agent'] = USER_AGENT
        req['Cache-Control'] = 'no-cache'
        req['Accept-Language'] = 'ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7,la;q=0.6,de;q=0.5'
        req['Upgrade-Insecure-Requests'] = '1'
        req
      end

      def parse_cookie(response)
        response.get_fields('set-cookie').map { |c| c.split('; ')[0] }.join('; ')
      end
    end
  end
end
