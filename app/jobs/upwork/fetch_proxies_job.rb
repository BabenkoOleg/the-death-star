class Upwork::FetchProxiesJob < Upwork::BaseJob
  queue_as :upwork_proxies

  def perform
    response = Net::HTTP.get(URI.parse('https://www.sslproxies.org'))
    page = Nokogiri::HTML(response)
    rows = page.xpath('//*[@id="proxylisttable"]/tbody').children

    log(:info, "Got new proxies: #{rows.count}")
    rows.each do |row|
      proxy = Upwork::Proxy.find_or_create_by(
        host: row.children[0].text,
        port: row.children[1].text.to_i
      )

      if Net::Ping::TCP.new(proxy.host, proxy.port).ping?
        if proxy.new_record?
          proxy.save
          log(:info, "#{proxy.host}:#{proxy.port}".yellow + ' created'.green)
        end
      else
        proxy.dead!
        log(:error, "#{proxy.host}:#{proxy.port}".yellow + ' is dead'.red)
      end
    end
  end
end
