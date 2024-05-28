def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.box-keywords-list-item').each do |item|
    job = {}
    job[:name] = item.at_css('.box-keywords-list-title').text.strip
    job[:description] = item.at_css('.box-keywords-list-abstract').text.strip
    job[:url] = URI.join("https://www.fu-berlin.de", item.at_css('a')['href']).to_s

    # Filter out non-job postings by checking if the description contains "Bewerbungsende"
    if job[:description].include?("Bewerbungsende")
      job_postings << job
    end
  end

  job_postings
end