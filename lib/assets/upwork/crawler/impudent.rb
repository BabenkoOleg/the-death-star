module Upwork
  module Crawler
    class Impudent
      API_URL = 'https://www.upwork.com'.freeze

      attr_accessor :proxy, :session_id

      def initialize
        @session_id = ENV['upwork_session_id']
      end

      def fetch_page(url)
        uri = URI.parse("#{API_URL}#{url[/\/jobs\/~.+/]}")

        http = Net::HTTP.new(uri.host, uri.port, proxy.host, proxy.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(uri)
        request["Pragma"] = "no-cache"
        request["Accept-Language"] = "ru,en-US;q=0.8,en;q=0.6"
        request["Upgrade-Insecure-Requests"] = "1"
        request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.139 Safari/537.36"
        request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
        request["Cache-Control"] = "no-cache"
        request["Authority"] = "www.upwork.com"
        request["Cookie"] = "session_id=#{session_id};"
        # request["Cookie"] = ENV['cookie']
        http.request(request)
      end
    end
  end
end

