def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table that contains job postings
  job_table = doc.at('.bite-jobs-list')
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Iterate over each row in the table, skipping the header row
  job_table.search('tr').each_with_index do |row, index|
    next if index == 0  # Skip the header row
    
    # Extract job details from the row
    columns = row.search('td')
    next if columns.empty?  # Skip if no columns found (just in case)
    
    # Extract the job name and description
    job_name = columns[1].text.strip
    job_description = columns[1].text.strip  # Assuming the description is the same as the name
    
    # Construct the URL for the job posting
    # Assuming a placeholder URL as no specific URLs are provided in the HTML snippet
    job_url = "https://www.lmu.de/de/die-lmu/arbeiten-an-der-lmu/stellenportal/professuren/#{URI.encode_www_form_component(job_name.downcase.gsub(' ', '-'))}"
    
    job_posting = {
      name: job_name,
      description: job_description,
      url: job_url
    }
    
    # Add the job posting to the list
    job_postings << job_posting
  end
  
  job_postings
end