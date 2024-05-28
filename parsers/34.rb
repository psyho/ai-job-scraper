def parse_job_postings(html)
  require 'nokogiri'
  require 'open-uri'

  def fetch_iframe_content(url)
    Nokogiri::HTML(URI.open(url))
  end

  doc = Nokogiri::HTML(html)
  iframe_url = doc.at_css('iframe')['src']
  iframe_doc = fetch_iframe_content(iframe_url)

  job_postings = []

  iframe_doc.css('a').each do |job_link|
    job_title = job_link.text.strip
    job_url = job_link['href']
    next unless job_url.include?('index') # Filter out non-job posting links

    job_url = "https://www.fernuni-hagen.de#{job_url}" unless job_url.start_with?('http')

    job_page = fetch_iframe_content(job_url)
    job_description = job_page.css('p, .job-description').map(&:text).join("\n").strip

    job_postings << {
      name: job_title,
      description: job_description,
      url: job_url
    }
  end

  job_postings
end