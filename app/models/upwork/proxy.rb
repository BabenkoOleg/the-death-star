class Upwork::Proxy < ApplicationRecord
  enum state: [:alive, :dead, :faulty]

  class << self
    def random_alive
      while true
        banned = where('got_recaptcha = ? and got_recaptcha_at < ?', true, DateTime.now - 5.minutes)
        banned.update_all(got_recaptcha: false, got_recaptcha_at: nil)

        proxy = where(state: :alive, got_recaptcha: false).sample

        break if proxy.nil?

        if proxy.ping?
          break(proxy)
        else
          proxy.update(state: :dead)
        end
      end
    end
  end

  def ping?
    Net::Ping::TCP.new(host, port).ping?
  end
end
