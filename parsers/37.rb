def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('ul.up-content-link-list li').each do |li|
    job = {}
    link = li.at_css('a.up-document-link')
    next unless link

    job[:name] = link.text.strip
    job[:url] = URI.join('https://www.uni-potsdam.de', link['href']).to_s
    description = li.css('p').map(&:text).join(' ').strip
    job[:description] = description

    # Filter out non-job postings
    next if job[:name].empty? || job[:description].empty?

    job_postings << job
  end

  job_postings
end