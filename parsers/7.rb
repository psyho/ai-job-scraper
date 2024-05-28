def parse_job_postings(html)
  require 'nokogiri'
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.bite-jobs-list--row').each do |row|
    title_link = row.at_css('.bite-jobs-list--title a')
    next unless title_link

    name = title_link.text.strip
    description = row.at_css('.bite-jobs-list--title').text.strip.split("\n").last.strip
    url = title_link['href']
    url = "https://jobs.uni-rostock.de#{url}" unless url.start_with?('http')

    # Filter out non-job postings
    next unless name && description && url

    job_postings << { name: name, description: description, url: url }
  end

  job_postings
end