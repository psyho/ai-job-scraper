def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.uni-frankfurt.de"
  
  # Find the div that contains the job postings
  postings_container = doc.css('div#t_6cd73043_7224a2b5-a468-47ec-9e08-558efa25d1ed')
  
  # Iterate over each job posting within the container
  postings_container.css('div.text-widget p').each do |posting|
    # Extract the job name and URL from the anchor tag
    link = posting.css('a').first
    next unless link && link['href'].include?('.pdf') # Skip if no link found or if it's not a PDF link
    
    job_name = link.text.strip
    job_url = base_url + link['href']
    
    # The description is the text of the paragraph, excluding the link text
    description = posting.text.gsub(job_name, '').strip
    
    # Append the job posting to the list
    job_postings << {
      name: job_name,
      description: description,
      url: job_url
    }
  end
  
  # Return the list of job postings
  job_postings
end