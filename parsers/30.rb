def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table with job postings
  postings_table = doc.at_css('#vacancies')
  
  # Initialize an array to hold all job postings
  job_postings = []
  
  # Iterate over each row in the table, skipping the header row
  postings_table.css('tbody tr').each do |row|
    # Extract job details from each row
    id = row.at_css('td:nth-child(1)').text.strip
    title_element = row.at_css('td:nth-child(2) a')
    title = title_element.text.strip
    institute = row.at_css('td:nth-child(3)').text.strip
    salary_grade = row.at_css('td:nth-child(4)').text.strip
    application_deadline = row.at_css('td:nth-child(5)').text.strip
    start_date = row.at_css('td:nth-child(6)').text.strip
    
    # Attempt to construct or extract the URL for the job posting
    # Assuming the URL might be embedded within the title element as an 'href' attribute
    url = title_element['href']
    url = url ? URI.join('https://www.uni-goettingen.de', url).to_s : nil
    
    # Construct the job posting hash
    job_posting = {
      id: id,
      name: title,
      description: "Institute: #{institute}, Salary Grade: #{salary_grade}, Application Deadline: #{application_deadline}, Start Date: #{start_date}",
      url: url
    }
    
    # Add the job posting to the list
    job_postings << job_posting
  end
  
  job_postings
end