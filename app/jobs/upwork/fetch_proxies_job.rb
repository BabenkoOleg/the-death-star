class Upwork::FetchProxiesJob < ApplicationJob
  queue_as :upwork

  def perform
    response = Net::HTTP.get(URI.parse('https://www.sslproxies.org'))
    page = Nokogiri::HTML(response)
    rows = page.xpath('//*[@id="proxylisttable"]/tbody').children

    rows.each do |row|
      proxy = Upwork::Proxy.find_or_create_by(
        host: row.children[0].text,
        port: row.children[1].text.to_i
      )

      if Net::Ping::TCP.new(proxy.host, proxy.port).ping?
        proxy.save if proxy.new_record?
      else
        proxy.dead!
      end
    end
  end
end
