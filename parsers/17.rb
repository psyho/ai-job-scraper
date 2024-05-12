def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table body that contains job postings
  job_rows = doc.xpath('//table[@class="ubf-ugc__table ubf-ugc__table--applicationTile"]/tbody/tr')
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Iterate over each job row to extract details
  job_rows.each do |row|
    # Extract job title, institution, and URL from the row
    title_cell = row.at_xpath('td[1]/a')
    institution_cell = row.at_xpath('td[2]/a')
    url_cell = row.at_xpath('td[1]/a')
    
    # Check if the cells exist and extract text
    title = title_cell ? title_cell.text.strip : nil
    institution = institution_cell ? institution_cell.text.strip : nil
    url = url_cell ? url_cell['href'].strip : nil
    
    # Ensure that the extracted data is valid
    next if title.nil? || institution.nil? || url.nil?
    
    # Append the job posting to the list
    job_postings << {
      name: title,
      description: institution,
      url: url
    }
  end
  
  job_postings
end