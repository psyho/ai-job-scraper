def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.news').each do |news_item|
    job = {}
    job[:name] = news_item.css('h3').text.strip

    description_parts = []
    news_item.css('p').each do |p|
      description_parts << p.text.strip
    end
    job[:description] = description_parts.join("\n")

    more_link = news_item.css('a.mehr').first
    if more_link
      uri = URI.parse(more_link['href'])
      job[:url] = uri.absolute? ? more_link['href'] : "https://www.uni-halle.de#{more_link['href']}"
    end

    # Filter out non-job postings
    if job[:name].downcase.include?('professur') || job[:name].downcase.include?('professorship')
      job_postings << job
    end
  end

  job_postings
end