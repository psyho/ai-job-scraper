def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for making absolute URLs
  base_url = "https://www.uni-osnabrueck.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Find all paragraph tags within the div with class 'eb2'
  doc.css('.eb2 p').each do |p|
    # Each job posting is contained within a paragraph tag
    # Extract the job name and URL from the anchor tag
    link = p.at_css('a')
    next unless link && link.text.include?('Professur')  # Skip if no link or not a job posting
    
    job_name = link.text.strip
    job_url = link['href']
    
    # Ensure the URL is absolute
    job_url = base_url + job_url unless job_url.start_with?('http')
    
    # The description follows the job name and is within the same paragraph
    # Remove the anchor tags and any other unnecessary elements
    p.search('a').remove
    description = p.text.strip.gsub(/\s+/, ' ')  # Normalize whitespace
    
    # Add the job posting to the list
    job_postings << {
      name: job_name,
      description: description,
      url: job_url
    }
  end
  
  job_postings
end