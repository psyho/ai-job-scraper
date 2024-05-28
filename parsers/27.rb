
def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('div[data-bite-jobs-api-listing] ul.link-text-list li').each do |li|
    job = {}
    link = li.at_css('a')
    job[:name] = link.at_css('div').text.strip.split("\n").first.strip
    job[:description] = link.at_css('span').text.strip
    job[:url] = URI.join('https://stellenangebote.uni-marburg.de', link['href']).to_s
    job_postings << job
  end

  job_postings
end