def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.double-grid').each do |grid|
    name = nil
    description = ""
    url = nil

    grid.css('p').each do |p|
      if p.css('strong').any?
        description += p.text.strip + "\n"
      elsif p.css('a').any? && p.css('a').attr('href').value.end_with?('.pdf')
        name = p.css('a').text.strip
        url = "https://www.uni-frankfurt.de" + p.css('a').attr('href').value
        description += p.text.strip + "\n"
      else
        description += p.text.strip + "\n"
      end
    end

    if name && url
      job_postings << { name: name, description: description.strip, url: url }
    end
  end

  job_postings
end