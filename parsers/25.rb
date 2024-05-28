def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('table.line tbody tr').each_with_index do |row, index|
    next if index == 0 # Skip the header row

    cells = row.css('td')
    next if cells.size < 4 # Ensure the row has enough cells to be a valid job posting

    job_title_links = cells[0].css('a')
    department = cells[1].text.strip
    reference_number = cells[2].text.strip
    application_deadline = cells[3].text.strip

    job_title_links.each do |link|
      job_postings << {
        name: link.text.strip,
        description: "Department: #{department}, Reference Number: #{reference_number}, Application Deadline: #{application_deadline}",
        url: URI.join("https://www.uni-giessen.de", link['href']).to_s
      }
    end
  end

  job_postings
end