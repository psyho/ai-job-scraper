def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Base URL for constructing absolute URLs
  base_url = "https://jobs.fernuni-hagen.de"
  
  # Find all job postings
  job_tiles = doc.css('li.job-tile')
  
  # Extract details from each job posting
  jobs = job_tiles.map do |job_tile|
    # Construct the absolute URL
    relative_url = job_tile.at_css('.tiletitle a')['href']
    absolute_url = base_url + relative_url
    
    {
      name: job_tile.at_css('.tiletitle a').text.strip,
      description: job_tile.css('.section-field').map { |field| "#{field.text.strip.gsub(/\s+/, ' ')}" }.uniq.join(' '),
      url: absolute_url
    }
  end
  
  # Filter out any invalid job postings if necessary
  jobs.select { |job| job[:name] != '' && job[:url] != base_url }
end