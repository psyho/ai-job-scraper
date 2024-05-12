def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Base URL for constructing absolute URLs
  base_url = "https://jobs.fernuni-hagen.de"
  
  # Find all job postings
  job_tiles = doc.css('li.job-tile')
  
  # Extract details from each job posting
  jobs = job_tiles.map do |tile|
    # Extract job name
    job_name = tile.at_css('.tiletitle a')&.text&.strip
    
    # Extract job description
    job_description_elements = tile.css('.section-field')
    job_description = job_description_elements.map do |field|
      label = field.at_css('.section-label')&.text&.strip
      value = field.at_css('div')&.text&.strip
      "#{label}: #{value}" if label && value
    end.compact.uniq.join(', ')  # Ensure uniqueness and compactness of description elements
    
    # Extract job URL and make it absolute
    relative_url = tile.at_css('.tiletitle a')['href']
    job_url = base_url + relative_url if relative_url
    
    # Construct job hash if job name and URL are present
    if job_name && job_url
      {
        name: job_name,
        description: job_description,
        url: job_url
      }
    end
  end
  
  # Filter out nil entries (in case some job tiles were missing necessary data)
  jobs.compact
end