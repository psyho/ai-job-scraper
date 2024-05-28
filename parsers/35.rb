def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_listings = []

  doc.css('li.job-tile').each do |job_tile|
    job = {}

    # Extract job title
    job[:name] = job_tile.at_css('.jobTitle-link').text.strip

    # Extract job URL
    job[:url] = "https://jobs.fernuni-hagen.de" + job_tile.at_css('.jobTitle-link')['href']

    # Extract job description details
    description = []
    job_tile.css('.section-field').each do |field|
      label = field.at_css('.section-label')&.text&.strip
      value = field.at_css('div')&.text&.strip
      description << "#{label}: #{value}" if label && value
    end
    job[:description] = description.uniq.join(", ")

    # Filter out non-job postings (if any specific criteria are known, apply them here)
    if job[:name] && job[:url] && job[:description]
      job_listings << job
    end
  end

  job_listings
end