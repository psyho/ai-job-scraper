def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the job postings table by its unique structure
  job_postings = []
  table = doc.css('table').find { |t| t.css('td').any? { |td| td.text.include?('Stellenbezeichnung') } }
  
  # Iterate over each row in the table, skipping the header row
  table.css('tr')[1..-1].each do |row|
    cells = row.css('td')
    next if cells.empty? || cells[0].css('a').empty?  # Skip empty rows or rows without a link
    
    # Extract job name and URL
    name = cells[0].text.strip
    url = cells[0].css('a')[0]['href'].strip
    next unless url.start_with?('http')  # Ensure URL is absolute

    # Extract description from subsequent cells, excluding empty or placeholder cells
    description_parts = cells[1..-1].map { |cell| cell.text.strip }.reject(&:empty?)
    description = description_parts.join(', ')
    
    # Append the job posting to the list if it contains meaningful information
    job_postings << { name: name, description: description, url: url } unless name.empty? || description.empty?
  end
  
  job_postings
end