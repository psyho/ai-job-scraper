def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  base_url = 'https://www.europa-uni.de/de/struktur/verwaltung/dezernat_2/stellenausschreibung/'

  doc.css('.box_blau').each do |box|
    job = {}
    job[:name] = box.at_css('span strong')&.text || box.at_css('strong')&.text
    next unless job[:name] && job[:name].match(/(akademisches|nichtwissenschaftliches|studentisches|Professuren|Berufsausbildung)/i)

    description = []
    box.xpath('following-sibling::div').each do |sibling|
      break if sibling['class'] == 'box_blau'
      description << sibling.text.strip
    end
    job[:description] = description.join("\n")

    url = box.xpath('following-sibling::div//a').map { |a| a['href'] }.find { |href| href && !href.include?('#mce_temp_url#') }
    job[:url] = url ? URI.join(base_url, url).to_s : nil

    job_postings << job if job[:url]
  end

  job_postings
end