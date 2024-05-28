def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  table = doc.at('div#ext-gen1978 table')
  return job_postings unless table

  table.css('tr').each_with_index do |row, index|
    next if index == 0 # Skip the header row

    cells = row.css('td')
    next if cells.empty? || cells[0].text.strip.empty?

    job_title = cells[0].at('a')&.text&.strip
    department = cells[1]&.text&.strip
    rank = cells[2]&.text&.strip
    application_deadline = cells[3]&.text&.strip
    url = cells[0].at('a')&.[]('href')

    # Filter out rows that are not actual job postings
    next unless job_title && department && url && !job_title.empty? && !department.empty? && !url.empty?

    job_postings << {
      name: job_title,
      description: "Department: #{department}, Rank: #{rank}, Application Deadline: #{application_deadline}",
      url: url.start_with?('http') ? url : "https://www.uni-goettingen.de#{url}"
    }
  end

  job_postings
end