def parse_job_postings(html)
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting rows in the table
  job_rows = doc.css('#bewerberportal tr.datensatz')
  
  # Extract job details from each row
  jobs = job_rows.map do |row|
    {
      name: row.at_css('td a').text.strip,
      description: row.css('td')[0].children[2].text.strip,
      url: "https://www.uni-hamburg.de" + row.at_css('td a')[:href]
    }
  end
  
  jobs
end