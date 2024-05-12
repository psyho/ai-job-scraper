def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Select all div elements with class 'contentboxGrey'
  doc.css('.contentboxGrey').each do |content_box|
    # Initialize a hash to store the job posting details
    job_posting = {}
    
    # Extract the name and description from the content box
    name = content_box.at_css('h2').text.strip if content_box.at_css('h2')
    description_elements = content_box.css('p')
    description = description_elements.map(&:text).join("\n").strip unless description_elements.empty?
    
    # Extract the URL if there is an 'a' tag within the description
    url_element = content_box.at_css('a')
    url = url_element[:href] if url_element && url_element[:href]
    
    # Ensure URL is absolute if it is not nil
    if url && !url.start_with?('http', 'mailto')
      url = "https://www.uni-frankfurt.de#{url}"
    end
    
    # Populate the hash with the extracted details
    job_posting[:name] = name if name
    job_posting[:description] = description if description
    job_posting[:url] = url if url
    
    # Add the job posting hash to the array if it contains a name or description
    job_postings << job_posting if job_posting[:name] || job_posting[:description]
  end
  
  # Return the array of job postings
  job_postings
end