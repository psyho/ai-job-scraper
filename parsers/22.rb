def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  job_postings = []

  base_url = "https://uni.ruhr-uni-bochum.de"

  doc.css('.bite-jobs-list--row').each do |job_row|
    name = job_row.css('.bite-jobs-list--title').text.strip
    department = job_row.css('.bite-jobs-list--orgaeinheit').text.strip
    online_since = job_row.css('.bite-jobs-list--fields--block').find { |block| block.text.include?('Online seit:') }&.text&.strip
    job_type = job_row.css('.bite-jobs-list--fields--block').find { |block| block.text.include?('Job:') }&.text&.strip
    hours_per_week = job_row.css('.bite-jobs-list--fields--block').find { |block| block.text.include?('Umfang:') }&.text&.strip
    application_deadline = job_row.css('.bite-jobs-list--fields--block').find { |block| block.text.include?('Bewerben bis:') }&.text&.strip

    description = "Department: #{department}, #{job_type}, #{hours_per_week}, #{application_deadline}, #{online_since}"
    url = job_row['target'] ? URI.join(base_url, job_row['target']).to_s : nil

    next if name.empty? || description.empty? || url.nil?

    job_postings << { name: name, description: description, url: url }
  end

  job_postings
end