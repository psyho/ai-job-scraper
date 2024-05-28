def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'

  doc = Nokogiri::HTML(html)
  base_url = "https://haushalt-und-personal.hu-berlin.de"
  job_listings = []

  job_listing_section = doc.at('dl.jobListing')

  if job_listing_section
    job_listing_section.css('dd').each do |job_entry|
      job = {}

      job_link = job_entry.at('a')
      if job_link
        job[:name] = job_link.text.strip
        job[:url] = URI.join(base_url, job_link['href']).to_s
      end

      job_description = job_entry.at('p')
      if job_description
        job[:description] = job_description.text.strip
      end

      job_details = job_entry.css('small').map(&:text).join(' ')
      job[:details] = job_details.strip unless job_details.empty?

      # Filter out non-job postings
      if job[:name] && job[:url] && job[:url].include?('/de/personal/stellenausschreibungen/')
        job_listings << job
      end
    end
  end

  job_listings
end