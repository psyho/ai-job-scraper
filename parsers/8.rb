def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.uni-rostock.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all article elements that contain job postings
  articles = doc.css('.plugin-list__item')
  
  # Map each article to a hash containing the job posting details
  job_postings = articles.map do |article|
    # Extract elements
    title_element = article.at_css('h3 a')
    description_element = article.at_css('.teaser-text')
    url_element = title_element['href'] if title_element
    
    # Check if all elements are present
    next unless title_element && description_element && url_element
    
    # Prepare data
    name = title_element.text.strip
    description = description_element.text.gsub(/\s+/, ' ').strip
    url = url_element.start_with?('http') ? url_element : base_url + url_element
    
    # Construct the hash
    {
      name: name,
      description: description,
      url: url
    }
  end
  
  # Remove nil entries (from 'next' in the loop) and return
  job_postings.compact
end