def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_listings = []

  doc.css('.c-jobsitem').each do |job_item|
    name = job_item.at_css('.c-jobsitem__name a').text.strip
    url = "https://www.uni-hannover.de" + job_item.at_css('.c-jobsitem__name a')['href']
    description = []

    faculty = job_item.at_css('.c-jobsitem__faculty')
    description << faculty.text.strip if faculty

    deadline = job_item.at_css('.c-jobsitem__deadline')
    description << deadline.text.strip if deadline

    extra = job_item.at_css('.c-jobsitem__extra')
    description << extra.text.strip if extra

    job_listings << { name: name, description: description.join(' '), url: url }
  end

  job_listings.select { |job| job[:name] && job[:url] }
end