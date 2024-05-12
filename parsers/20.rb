def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job postings
  job_postings = doc.css('.offer-list li')
  
  # Map each job posting to a hash
  jobs = job_postings.map do |job|
    link = job.at_css('a.link-detailseite')
    next unless link && link['href'] # Skip if no link or href is found

    url = link['href'].strip
    next unless url.start_with?('https://') # Ensure URL is absolute and starts with 'https://'

    # Extract job name and description
    job_texts = job.css('.offer-text').map(&:text).map(&:strip)
    next if job_texts.empty? # Skip if no text content is found

    name = job_texts.first
    description = job_texts[1..-1].join(' ') # Combine all but the first element as description

    { name: name, description: description, url: url }
  end.compact # Remove nil entries resulting from 'next' statements
  
  jobs
end