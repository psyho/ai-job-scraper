def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('div.news div.plugin-list__content--full-width').each do |job_element|
    job = {}
    teaserbox = job_element.at_css('a.teaserbox')
    next unless teaserbox

    job[:name] = teaserbox.at_css('h3.h2-style').text.strip
    job[:url] = URI.join("https://www.uni-greifswald.de", teaserbox['href']).to_s
    
    description = []
    teaserbox.css('p time, p span').each do |desc_element|
      description << desc_element.text.strip
    end
    job[:description] = description.reject(&:empty?).join(' | ')

    job_postings << job
  end

  job_postings
end