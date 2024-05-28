def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.entry').each do |entry|
    next unless entry.css('.title a').any? # Skip entries without job postings

    job = {}
    job[:name] = entry.css('.title a').text.strip
    job[:description] = entry.css('.institution').text.strip
    job[:url] = entry.css('.title a').attr('href')&.value

    # Ensure the URL is absolute
    if job[:url] && !job[:url].start_with?('http')
      job[:url] = "https://www.uni-jena.de#{job[:url]}"
    end

    job_postings << job if job[:url] # Only include jobs with valid URLs
  end

  job_postings
end