def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('article').each do |article|
    job = {}

    # Extract job title
    job[:name] = article.at_css('h1').text.strip

    # Extract job description
    description = []
    article.css('p, ul').each do |element|
      description << element.text.strip
    end
    job[:description] = description.join("\n")

    # Extract job URL
    pdf_link = article.at_css('a.MIME--pdf')
    if pdf_link
      job[:url] = pdf_link['href']
      job[:url] = URI.join('https://www.uni-kiel.de', job[:url]).to_s unless job[:url].start_with?('http')
    end

    # Filter out non-job postings
    if job[:name] && job[:description] && job[:url]
      job_postings << job
    end
  end

  job_postings
end