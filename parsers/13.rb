def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.c-preview-item--news').each do |job|
    name = job.at_css('.c-preview-item__text').text.strip
    url = "https://www.leuphana.de" + job.at_css('a')['href']
    description = job.at_css('.c-preview-item__text').text.strip

    # Filter out non-job postings if necessary
    if name.downcase.include?('wissenschaftliche') || name.downcase.include?('mitarbeiter')
      job_postings << { name: name, description: description, url: url }
    end
  end

  job_postings
end