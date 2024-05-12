def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for absolute paths
  base_url = "https://www.uni-greifswald.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an empty array to store job postings
  job_postings = []
  
  # Find all 'div' elements that contain job postings
  doc.css('div.news div.plugin-list__content--full-width').each do |node|
    # Extract the job name and description from the 'h3' element inside 'a' tag
    job_link = node.at_css('a.teaserbox')
    next unless job_link  # Skip if no link is found

    job_name = job_link.at_css('h3').text.strip if job_link.at_css('h3')
    job_description = job_link.at_css('p').text.strip if job_link.at_css('p')
    
    # Extract the URL from the 'href' attribute of the 'a' element
    job_url = job_link['href']
    job_url = base_url + job_url unless job_url.start_with?('http', 'https')
    
    # Create a hash for the job posting and append it to the job_postings array
    job_postings << {
      name: job_name,
      description: job_description,
      url: job_url
    }
  end
  
  # Return the array of job postings
  job_postings
end