def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_listings = []

  doc.css('div[data-bite-jobs-api-listing] ul.link-text-list li').each do |li|
    job = {}
    job[:name] = li.at_css('a div').text.strip
    job[:url] = li.at_css('a')['href']
    job[:url] = "https://stellenangebote.uni-marburg.de#{job[:url]}" unless job[:url].start_with?('http')
    job[:description] = li.at_css('span').text.strip

    # Filter out non-job postings
    if job[:name].include?('Professur') || job[:description].include?('Bewerbungsfrist')
      job_listings << job
    end
  end

  job_listings
end