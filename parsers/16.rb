def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.uni-bielefeld.de"
  
  # Find all accordion content sections which contain job postings
  accordion_contents = doc.css('.ubf-accordion__contentWrapper')
  
  # Iterate over each accordion content to find job postings
  accordion_contents.each do |content|
    # Get the faculty name from the preceding toggler
    faculty_name = content.previous_element.css('.ubf-accordion__togglerLabel').text.strip
    
    # Find all job posting links within the content section
    job_links = content.css('ul li a')
    
    # Iterate over each job posting link
    job_links.each do |link|
      # Construct absolute URL if it's not already
      url = link['href'].start_with?('http') ? link['href'] : base_url + link['href']
      
      # Add job posting to the list if it's a valid job posting link
      if url.include?('/uni/karriere/professuren/')
        job_postings << {
          name: link.text.strip,
          description: faculty_name,
          url: url
        }
      end
    end
  end
  
  job_postings
end