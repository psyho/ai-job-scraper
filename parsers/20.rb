def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  base_url = "https://stellen.uni-muenster.de"

  doc.css('ul.offer-list li').each do |li|
    job = {}
    job[:name] = li.css('p.offer-text').first.text.strip
    job[:description] = li.css('p.offer-text').map(&:text).join(' ').strip
    relative_url = li.css('a.link-detailseite').first['href']
    job[:url] = URI.join(base_url, relative_url).to_s
    job_postings << job if job[:url].include?('jobposting')
  end

  job_postings
end