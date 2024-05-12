def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for absolute paths, adjusted to include the correct path for job postings
  base_url = "https://www.uni-muenster.de/Rektorat/Stellen/"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the list that contains job offers
  job_list = doc.css('.offer-list')
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Iterate over each job posting in the list
  job_list.css('li').each do |job_item|
    # Extract the job name and URL from the anchor tag within the paragraph with class 'offer-text'
    job_link = job_item.at_css('.offer-text a')
    next unless job_link  # Skip if no link is found
    
    job_name = job_link.text.strip
    job_url = job_link['href']
    
    # Ensure the URL is absolute
    job_url = URI.join(base_url, job_url).to_s unless job_url.start_with?('http')
    
    # Extract the deadline from the anchor tag within the paragraph with class 'deadline'
    deadline = job_item.at_css('.deadline a').text.strip
    
    # Append the job posting to the list as a hash
    job_postings << {
      name: job_name,
      description: "Deadline: #{deadline}",
      url: job_url
    }
  end
  
  # Return the array of job postings
  job_postings
end