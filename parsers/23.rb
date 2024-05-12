def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table that contains job postings
  job_table = doc.at_css('.bite-jobs-list')
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Iterate over each row in the table, skipping the header row
  job_table.css('tr').each_with_index do |row, index|
    next if index == 0  # Skip the header row
    
    # Extract job details from the row
    cells = row.css('td')
    next if cells.empty?  # Skip if no cells (just in case)
    
    job_postings << {
      name: cells[1].text.strip,  # Job title
      description: "#{cells[0].text.strip} - #{cells[2].text.strip}",  # Institution and compensation
      url: "https://www.lmu.de/de/die-lmu/arbeiten-an-der-lmu/stellenportal/wissenschaft/"  # Static URL as no specific URLs are provided in the HTML
    }
  end
  
  job_postings
end