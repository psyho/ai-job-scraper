def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting entries within the specific container for job postings
  entries = doc.css('.entries .entry')
  
  # Extract details from each entry
  job_postings = entries.map do |entry|
    name = entry.at_css('.title a')&.text&.strip
    description = entry.at_css('.institution')&.text&.strip || ""
    url = entry.at_css('.title a')&.[]('href')&.strip
    
    # Ensure that only valid job postings with URLs are included
    if url && !url.empty? && name && !name.empty?
      {
        name: name,
        description: description,
        url: url
      }
    end
  end
  
  # Remove nil entries and return the job postings
  job_postings.compact
end