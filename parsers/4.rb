def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting containers
  postings = doc.css('div.news')
  
  # Extract details from each posting
  job_postings = postings.map do |posting|
    # Extract the job name
    name = posting.at_css('h3').text.strip
    
    # Extract and clean the description
    description_parts = posting.css('p').map(&:text).map(&:strip)
    description = description_parts.join(' ').gsub(/\s*\[ mehr \.\.\. \]\s*/, ' ').strip
    
    # Extract the URL and validate it
    url = posting.at_css('a.mehr')['href'].strip if posting.at_css('a.mehr')
    
    # Ensure the URL is valid
    next unless url && url.start_with?('https://')
    
    { name: name, description: description, url: url }
  end
  
  job_postings.compact # Remove nil entries resulting from 'next unless'
end