def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.leuphana.de"
  
  # Find all job postings
  job_postings = doc.css('.c-preview-item--news')
  
  # Extract details from each job posting
  jobs = job_postings.map do |job|
    # Extract the URL and make it absolute
    relative_url = job.at_css('.c-preview-item__link')['href']
    absolute_url = base_url + relative_url
    
    # Extract the job name and description
    job_name = job.at_css('.c-preview-item__text').text.strip
    job_description = job_name  # Assuming description is the same as the name for simplicity
    
    {
      name: job_name,
      description: job_description,
      url: absolute_url
    }
  end
  
  # Filter out any non-valid job postings if necessary (e.g., based on content checks)
  jobs.select { |job| job[:name].include?("Mitarbeiter") }
end