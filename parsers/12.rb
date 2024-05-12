def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table with job postings
  postings_table = doc.at_css('table.alternating.listing.vertical')
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Iterate over each row in the table body
  postings_table.css('tbody tr').each do |row|
    # Get the cells in the row
    cells = row.css('td')
    next if cells.empty? || cells.size < 3  # Skip rows that might be empty or headers or incomplete
    
    # Extract the job name and URL from the first cell
    link = cells[0].at_css('a')
    next unless link && !link['href'].nil? && !link.text.strip.empty?  # Skip if no link is found or if it's empty
    
    job_name = link.text.strip
    job_url = link['href'].strip
    job_url = "https://www.berufungen.uni-kiel.de" + job_url unless job_url.start_with?('http')
    
    # Extract the application deadline and status from the second and third cells
    deadline = cells[1].text.strip
    status = cells[2].text.strip
    
    # Combine deadline and status to form the description
    description = "Deadline: #{deadline}, Status: #{status}"
    
    # Append the job posting to the list
    job_postings << {
      name: job_name,
      description: description,
      url: job_url
    }
  end
  
  job_postings
end