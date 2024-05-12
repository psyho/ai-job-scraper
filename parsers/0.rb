def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Find the table rows that contain job postings
  job_rows = doc.css('table tr')
  
  # Iterate over each row to extract job details
  job_rows.each do |row|
    # Skip rows that do not have the expected structure or do not contain job relevant data
    next unless row.css('td').size >= 3
    
    # Extract job name, description, and URL from the columns
    name = row.css('td')[0].text.strip
    description = row.css('td')[1].text.strip
    url_element = row.css('td')[1].css('a').first
    
    # Skip rows that do not contain meaningful names or descriptions
    next if name.empty? || description.empty? || name == "Einrichtung/Lehrstuhl"
    
    # Extract the URL if it exists and is a valid link
    url = url_element && url_element['href'] && (url_element['href'].start_with?('http', '/')) ? url_element['href'] : nil
    
    # Create a hash for the job posting and add it to the list
    job_postings << {
      name: name,
      description: description,
      url: url
    }
  end
  
  job_postings
end