
def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('table.listing tbody tr').each do |row|
    cells = row.css('td')
    next if cells.empty?

    name = cells[0].css('a').text.strip
    next if name.empty? || !name.end_with?('.pdf')

    url = cells[0].css('a').first['href']
    url = URI.join('https://www.berufungen.uni-kiel.de', url).to_s
    description = "Application Deadline: #{cells[1].text.strip}"

    job_postings << { name: name, description: description, url: url }
  end

  job_postings
end