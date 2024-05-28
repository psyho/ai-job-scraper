def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('#vacancies tbody tr').each do |row|
    job = {}
    columns = row.css('td')

    job_title_element = columns[1].css('a').first
    next unless job_title_element # Skip rows without a job title link

    job[:name] = job_title_element.text.strip
    job[:description] = {
      department: columns[2].text.strip,
      salary: columns[3].text.strip,
      application_deadline: columns[4].text.strip,
      start_date: columns[5].text.strip
    }
    job[:url] = URI.join("https://www.uni-goettingen.de", job_title_element['href']).to_s if job_title_element['href']

    job_postings << job
  end

  job_postings
end