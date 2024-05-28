def parse_job_postings(html)
  require 'nokogiri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.eb2 p').each do |job_element|
    job = {}
    job[:name] = job_element.at_css('a').text.strip
    job[:url] = "https://www.uni-osnabrueck.de" + job_element.at_css('a')['href']
    job[:description] = job_element.children.map(&:text).map(&:strip).reject(&:empty?).drop(1).join(", ")
    job_postings << job unless job[:description].empty?
  end

  job_postings
end