def parse_job_postings(html)
  require 'nokogiri'
  doc = Nokogiri::HTML(html)
  job_postings = []

  # Extract the job listing from the first section
  doc.css('.c-preview-item').each do |item|
    name = item.css('.c-preview-item__text').text.strip
    url = item.css('a').first['href']
    url = "https://www.leuphana.de#{url}" unless url.start_with?('http')
    description = "Not explicitly provided in the HTML snippet."
    job_postings << { name: name, description: description, url: url }
  end

  # Extract the job listings from the second section
  doc.css('.c-content-menu__link').each do |item|
    name = item.text.strip
    description_element = item.parent.next_element
    description = description_element ? description_element.text.strip : "Description not provided."
    next if name.empty? || description.empty? || description == "Description not provided."
    url = "Not provided in the HTML snippet."
    job_postings << { name: name, description: description, url: url }
  end

  job_postings
end