class Upwork::Proxy < ApplicationRecord
  include Upwork::Occupied

  enum state: [:alive, :dead]

  class << self
    def free_and_alive
      banned = where('got_recaptcha = ? and got_recaptcha_at < ?', true, DateTime.now - 5.minutes)
      banned.update_all(got_recaptcha: false, got_recaptcha_at: nil)

      while true
        proxy = free.where(state: :alive, got_recaptcha: false).sample

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
