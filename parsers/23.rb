def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_listings = []

  doc.css('table.bite-jobs-list tr').each_with_index do |row, index|
    next if index == 0 # Skip the header row

    job = {}
    columns = row.css('td')

    job[:name] = columns[1].text.strip
    job[:description] = "Department: #{columns[0].text.strip}, Compensation: #{columns[2].text.strip}, Application Deadline: #{columns[3].text.strip}"
    job[:url] = "https://www.lmu.de/de/die-lmu/arbeiten-an-der-lmu/stellenportal/wissenschaft/#{columns[1].text.strip.downcase.gsub(' ', '-').gsub(/[^\w-]/, '')}"

    job_listings << job
  end

  job_listings
end