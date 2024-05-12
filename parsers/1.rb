def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for absolute paths
  base_url = "https://www.fu-berlin.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting containers
  postings = doc.css('.box-keywords-list-item')
  
  # Map each posting to a hash with the required details
  postings.map do |posting|
    # Construct the absolute URL
    relative_url = posting.at_css('a')[:href]
    absolute_url = base_url + relative_url
    
    {
      name: posting.at_css('h3').text.strip,
      description: posting.at_css('p').text.strip.gsub("\n", " ").squeeze(" "),
      url: absolute_url
    }
  end
end