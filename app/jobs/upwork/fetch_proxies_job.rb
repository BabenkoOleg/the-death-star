class Upwork::FetchProxiesJob < Upwork::BaseJob
  queue_as :upwork_proxies

  def perform
    response = Net::HTTP.get(URI.parse('https://www.sslproxies.org'))
    page = Nokogiri::HTML(response)
    children = page.xpath('//*[@id="proxylisttable"]/tbody').children

    proxies = []

    threads = children.map do |child|
      Thread.new(child) do |row|
        proxy = Upwork::Proxy.new(
          host: row.children[0].text,
          port: row.children[1].text.to_i
        )

        proxy.state = Net::Ping::TCP.new(proxy.host, proxy.port).ping? ? :alive : :dead
        proxies << proxy
      end
    end

    threads.each { |thr| thr.join }

    proxies.each do |proxy|
      existed = Upwork::Proxy.find_by(host: proxy.host, port: proxy.port)

      if existed.present?
        existed.update(state: :alive) if existed.dead? && proxy.alive?
      else
        proxy.save
      end
    end
  end
end
