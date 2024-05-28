def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('tr.datensatz').each do |row|
    next if row['data-rid'].nil? || row['data-rid'].empty?

    job = {}
    job[:name] = row.at_css('td a').text.strip
    job[:description] = row.css('td')[1..3].map(&:text).join(', ').strip
    job[:url] = "https://www.uni-hamburg.de" + row.at_css('td a')['href']
    job_postings << job
  end

  job_postings
end