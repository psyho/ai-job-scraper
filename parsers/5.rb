def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job postings
  postings = doc.css('.plugin-list__content--full-width')
  
  # Extract details from each posting
  jobs = postings.map do |posting|
    # Extract the link element which contains the job details
    link = posting.at_css('a.teaserbox')
    
    # Check if the necessary elements are present
    next unless link && link.at_css('h3') && link.at_css('p')
    
    # Extract job name, description, and URL
    {
      name: link.at_css('h3').text.strip,
      description: link.at_css('p').text.gsub(/\s+/, ' ').strip,
      url: "https://www.uni-greifswald.de" + link['href']
    }
  end
  
  # Remove nil entries and return the jobs array
  jobs.compact
end