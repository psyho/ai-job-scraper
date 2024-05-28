def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('div.teaser2').each do |job_div|
    job = {}
    
    # Extract job title
    job[:name] = job_div.at_css('h3').text.strip
    
    # Extract job description
    description_parts = job_div.css('p').map(&:text).map(&:strip)
    job[:description] = description_parts.join("\n")
    
    # Extract job URL and ensure it's absolute
    relative_url = job_div.at_css('a.mehr')['href']
    job[:url] = URI.join('https://www.verwaltung.uni-halle.de', relative_url).to_s
    
    # Filter out non-job postings
    if job[:name].include?("Reg.-Nr.")
      job_postings << job
    end
  end

  job_postings
end