def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('div.eb2 p').each do |p|
    job = {}
    link = p.at_css('a')
    next unless link

    job[:name] = link.text.strip
    job[:url] = "https://www.uni-osnabrueck.de#{link['href']}"
    description_text = p.inner_html.split('<br />').map(&:strip).reject(&:empty?)
    job[:description] = description_text[1..-1].join(', ')

    job_postings << job
  end

  job_postings
end