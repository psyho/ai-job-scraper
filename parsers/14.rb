def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.leuphana.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job postings within the specific news list section
  job_postings = doc.css('.frame-type-news_newsliststicky .c-preview-item--news')
  
  # Extract details from each job posting
  jobs = job_postings.map do |job|
    # Extract the URL and make it absolute
    relative_url = job.at_css('a')&.[]('href')
    absolute_url = relative_url ? URI.join(base_url, relative_url).to_s : nil
    
    name = job.at_css('.c-preview-item__text')&.text&.strip
    description = job.at_css('.c-preview-item__text')&.text&.strip

    {
      name: name,
      description: description,
      url: absolute_url
    }
  end
  
  # Filter out entries without a valid URL, name, or description
  jobs.reject { |job| job[:name].nil? || job[:url].nil? || job[:description].nil? }
end