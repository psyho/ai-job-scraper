def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL to prepend to relative paths to form absolute URLs
  base_url = "https://www.uni-potsdam.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job postings listed under the specific class
  postings = doc.css('.up-content-link-list li')
  
  # Map each posting to a hash with the required details
  jobs = postings.map do |posting|
    next unless posting.at_css('a') && posting.css('p').any? # Ensure necessary elements are present
    
    {
      name: posting.at_css('a').text.strip,
      description: posting.css('p').map(&:text).join(' ').strip,
      url: base_url + posting.at_css('a')[:href]
    }
  end.compact # Remove nil entries resulting from 'next unless'
  
  jobs
end