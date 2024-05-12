def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job postings within the specific container
  job_postings = doc.css('div[data-bite-jobs-api-listing] li a')
  
  # Extract details from each job posting
  jobs = job_postings.map do |job|
    {
      name: job.at_css('div').text.strip.split("\n").first.strip,
      description: job.at_css('span')&.text&.strip,
      url: job['href']
    }
  end
  
  # Filter out non-job postings based on URL or missing name
  jobs.reject { |job| job[:url].include?('b-ite.de') || job[:name].empty? || job[:name].include?('Recruiting') || job[:name].include?('powered by BITE') }
end