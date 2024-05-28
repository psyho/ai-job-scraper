def parse_job_postings(html)
  require 'nokogiri'
  doc = Nokogiri::HTML(html)
  base_url = "https://uol.de"
  job_listings = []

  # Find all job listing sections
  job_sections = doc.css('div.ka-panel')

  job_sections.each do |section|
    job_type = section.at_css('h2.stellenart')&.text&.strip
    next unless job_type

    job_items = section.css('li')

    job_items.each do |item|
      job_title = item.at_css('strong.titel a')&.text&.strip
      job_url = item.at_css('strong.titel a')&.[]('href')
      job_deadline = item.at_css('em.bewerbungsschluss')&.text&.strip
      job_department = item.at_css('div.einrichtung')&.text&.strip

      next unless job_title && job_url && job_deadline && job_department

      job_url = base_url + job_url unless job_url.start_with?('http')

      job_listings << {
        name: job_title,
        description: "Type: #{job_type}, Department: #{job_department}, Deadline: #{job_deadline}",
        url: job_url
      }
    end
  end

  job_listings
end