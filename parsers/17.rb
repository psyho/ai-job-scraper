def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  base_url = "https://uni-bielefeld.hr4you.org"

  doc.css('table.ubf-ugc__table--applicationTile tbody tr').each do |row|
    job_title_element = row.at_css('td:nth-child(1) a')
    department_element = row.at_css('td:nth-child(2) a')
    application_deadline_element = row.at_css('td:nth-child(7) a')
    url_element = row.at_css('td:nth-child(1) a')

    next unless job_title_element && department_element && application_deadline_element && url_element

    job_title = job_title_element.text.strip
    department = department_element.text.strip
    application_deadline = application_deadline_element.text.strip
    relative_url = url_element['href']
    absolute_url = URI.join(base_url, relative_url).to_s

    # Filter out non-job postings
    next unless absolute_url.include?("job/view")

    job_postings << {
      name: job_title,
      description: "Department: #{department}, Application Deadline: #{application_deadline}",
      url: absolute_url
    }
  end

  job_postings
end