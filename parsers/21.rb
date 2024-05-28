def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_listings = []

  base_url = "https://www.uni-muenster.de/Rektorat/Stellen/"

  doc.css('ul.offer-list li').each do |offer|
    job_title_element = offer.at_css('p.offer-text a')
    job_deadline_element = offer.at_css('p.deadline a')

    next unless job_title_element && job_deadline_element

    job_title = job_title_element.text.strip
    job_url = URI.join(base_url, job_title_element['href']).to_s
    job_description = "Job Title: #{job_title}\nApplication Deadline: #{job_deadline_element.text.strip}"

    job_listings << {
      name: job_title,
      description: job_description,
      url: job_url
    }
  end

  job_listings
end