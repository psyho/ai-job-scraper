def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.plugin-list__content--full-width').each do |job_element|
    job = {}
    
    title_element = job_element.at_css('h3.h2-style')
    next unless title_element
    
    job[:name] = title_element.text.strip
    
    description_element = job_element.at_css('p')
    next unless description_element
    
    job[:description] = description_element.text.strip.gsub(/\s+/, ' ')
    
    url_element = job_element.at_css('a.teaserbox')
    next unless url_element
    
    job[:url] = URI.join("https://www.uni-greifswald.de", url_element['href']).to_s
    
    job_postings << job
  end

  job_postings
end