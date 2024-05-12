def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.uni-potsdam.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Select all div elements with the class 'up-content-link-list-text'
  doc.css('.up-content-link-list-text').each do |node|
    # Extract the job name and URL from the anchor tag
    link = node.at_css('a')
    next unless link  # Skip if no link is found
    
    name = link.text.strip
    url = link['href'].strip
    
    # Ensure URL is absolute
    url = base_url + url unless url.start_with?('http', 'https')
    
    # Extract the description, which is typically contained in <p> tags within the same div
    description_paragraphs = node.css('p')
    description = description_paragraphs.map(&:text).join(' ').strip
    
    # Filter out non-job postings based on the presence of keywords or structure
    next unless description.include?('Bewerbungsschluss') && url.end_with?('.pdf')
    
    # Append the job posting to the list
    job_postings << { name: name, description: description, url: url }
  end
  
  # Return the list of job postings
  job_postings
end