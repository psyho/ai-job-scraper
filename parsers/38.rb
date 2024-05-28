def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('.searchresult').each do |job|
    name = job.css('h3').text.strip
    description = job.css('.subline-teaser').text.strip
    additional_details = job.css('p').map(&:text).reject { |text| text.strip.empty? }.join(' ')
    description += " #{additional_details}" unless additional_details.empty?
    url = job.css('a.blocklink').attr('href').value
    absolute_url = URI.join('https://www.uni-leipzig.de', url).to_s

    # Filter out non-job postings
    if name && description && absolute_url
      job_postings << { name: name, description: description, url: absolute_url }
    end
  end

  job_postings
end