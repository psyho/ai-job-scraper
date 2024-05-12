def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for absolute paths
  base_url = "https://www.uni-hannover.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting elements
  job_elements = doc.css('.c-jobsitem')
  
  # Extract details from each job posting
  jobs = job_elements.map do |job_element|
    name_element = job_element.at_css('.c-jobsitem__name a')
    next unless name_element  # Skip if no name element found
    
    name = name_element.text.strip
    url = name_element['href']
    description_element = job_element.at_css('.c-jobsitem__extra')
    description = description_element ? description_element.text.strip : nil
    
    # Ensure URL is absolute
    url = base_url + url unless url.start_with?('http')
    
    # Return a hash with the job details
    { name: name, description: description, url: url }
  end
  
  jobs.compact  # Remove nil entries resulting from skipped non-job postings
end