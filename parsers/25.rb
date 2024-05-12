def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table that contains job postings
  postings_table = doc.css('table.line').first
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Iterate over each row in the table, skipping the header row
  postings_table.css('tr').each_with_index do |row, index|
    next if index == 0  # Skip the header row
    
    # Extract job name, description, and URL from the row
    cells = row.css('td')
    next if cells.size < 4  # Ensure there are enough cells to avoid non-job rows
    
    job_links = cells[0].css('a')
    organization_area = cells[1].text.strip
    reference_number = cells[2].text.strip
    application_deadline = cells[3].text.strip
    
    # Iterate over each job link in the first cell
    job_links.each do |link|
      name = link.text.strip
      url = link['href']
      description = "#{organization_area} - Reference Number: #{reference_number}, Application Deadline: #{application_deadline}"
      
      # Ensure URL is absolute
      unless url.start_with?('http')
        url = "https://www.uni-giessen.de#{url}" unless url.start_with?('/')
      end
      
      # Add job posting to the list
      job_postings << { name: name, description: description, url: url }
    end
  end
  
  job_postings
end