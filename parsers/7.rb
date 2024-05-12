def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting rows in the table
  job_rows = doc.css('.bite-jobs-list--row')
  
  # Extract job details from each row
  jobs = job_rows.map do |row|
    title_link = row.at_css('.bite-jobs-list--title-link a')
    next unless title_link  # Skip rows where the title link is not found

    # Extract the URL and ensure it's absolute
    url = title_link['href'].strip
    next unless url.start_with?('http')  # Ensure URL is absolute

    # Extract the full description text
    full_description = row.at_css('.bite-jobs-list--title').text.strip
    next if full_description.empty?  # Skip if description is empty

    # Attempt to separate the title from the rest of the description
    title = title_link.text.strip
    description = full_description.sub(title, '').strip

    {
      name: title,
      description: description,
      url: url
    }
  end.compact  # Remove nil entries from the array
  
  jobs
end