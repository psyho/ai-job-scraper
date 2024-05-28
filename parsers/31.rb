def parse_job_postings(html)
  require 'nokogiri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.contentboxGrey').each do |content_box|
    job = {}
    
    # Extract job title
    title_element = content_box.at_css('p strong')
    job[:name] = title_element ? title_element.text.strip : nil
    
    # Extract job description
    description = content_box.css('p').map(&:text).join("\n").strip
    job[:description] = description
    
    # Extract URL
    job[:url] = "https://www.uni-frankfurt.de/48794849/FB08___Philosophie_und_Geschichtswissenschaften"
    
    # Filter out non-job postings
    next if job[:name].nil? || job[:name].empty? || !description.include?("Wissenschaftliche*r Mitarbeiter*in")
    
    job_postings << job
  end

  job_postings
end