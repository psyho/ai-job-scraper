def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Assuming job postings are listed within div elements with a specific class
  doc.css('.job-offers .bite-jobs-list--row').each do |job_element|
    # Extract job details
    name = job_element.at_css('.bite-jobs-list--title')&.text&.strip
    description_elements = job_element.css('.bite-jobs-list--fields--block')
    description = description_elements.map { |elem| elem.text.strip }.join(' ')
    
    # Append the job posting to the list if it contains valid data
    job_postings << { name: name, description: description } if name && description
  end
  
  job_postings
end