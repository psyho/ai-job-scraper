def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  base_url = "https://www.uni-giessen.de"
  job_postings = []

  job_table = doc.at('table.line')
  return job_postings unless job_table

  job_table.css('tr')[1..-1].each do |row|
    columns = row.css('td')
    next if columns.size < 8

    job_title_element = columns[0].at('a')
    next unless job_title_element

    job_title = job_title_element.text.strip
    job_link = job_title_element['href']
    job_link = base_url + job_link unless job_link.start_with?('http')

    department = columns[2].text.strip
    organization = columns[3].text.strip
    duration = columns[4].text.strip
    salary = columns[5].text.strip
    reference_number = columns[6].text.strip
    application_deadline = columns[7].text.strip

    # Filter out non-job postings
    next if job_title.empty? || department.empty? || organization.empty?

    job_description = <<~DESC
      Department: #{department}
      Organization: #{organization}
      Duration: #{duration}
      Salary: #{salary}
      Reference Number: #{reference_number}
      Application Deadline: #{application_deadline}
    DESC

    job_postings << {
      name: job_title,
      description: job_description.strip,
      url: job_link
    }
  end

  job_postings
end