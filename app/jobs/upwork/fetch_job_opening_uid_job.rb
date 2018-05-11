class Upwork::FetchJobOpeningUidJob < ApplicationJob
  queue_as :upwork_opening_uid

  def perform(job_id)
    job = Upwork::Job.find(job_id)
    client = Upwork::Crawler::Impudent.new

    parsing = true

    job.update(parsing_state: :fetching_opening_uid)

    while parsing
      proxy = Upwork::Proxy.random_alive

      puts "#{proxy.host}:#{proxy.port}"

      break(job.update(parsing_state: :expecting_opening_uid)) if proxy.nil?

      client.proxy = proxy

      job.update(parsing_state: 'fetching_opening_uid')

      parsing = parse_job_page(job, client)
    end
  end

  private

  def parse_job_page(job, client)
    response = client.fetch_page(job.url)

    if response.code == '403'
      if response.body.match('This job is private')
        job.error_fetching_opening_uid!
        return false
      elsif response.body.match(/recaptcha/i)
        client.proxy.update(got_recaptcha: true, got_recaptcha_at: DateTime.now)
        sleep 10
        return true
      else
        sleep 10
        return true
      end
    end

    response.body =~ /openingUid',\s'(\d+)/

    if $1.present?
      job.update(opening_uid: $1, parsing_state: :expecting_client_info)
      return false
    end

    return true
  rescue Exception => e
    true
  end
end
