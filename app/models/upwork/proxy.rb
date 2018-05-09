class Upwork::Proxy < ApplicationRecord
  class << self
    def next
      while true
        proxy = first
        break proxy if proxy.ping?
        proxy.delete
      end
    end
  end

  def ping?
    Net::Ping::TCP.new(host, port).ping?
  end
end
