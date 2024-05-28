def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('article.plugin-list__item').each do |article|
    job = {}
    job[:name] = article.at_css('h3 a').text.strip
    job[:description] = article.at_css('.teaser-text p').text.strip
    job[:url] = URI.join("https://www.uni-rostock.de", article.at_css('h3 a')['href']).to_s

    # Filter out non-job postings by checking if the URL is a PDF
    if job[:url].end_with?('.pdf')
      job_postings << job
    end
  end

  job_postings
end