def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an empty array to store job postings
  job_postings = []
  
  # Find all article elements which contain job postings
  doc.css('article').each do |article|
    # Extract the job name
    name = article.at_css('h1').text.strip if article.at_css('h1')
    
    # Extract the job description
    description = article.css('p').map(&:text).join("\n").strip
    
    # Extract the URL if available
    url_element = article.at_css('a[href]')
    url = url_element['href'].strip if url_element && url_element['href']
    
    # Ensure URL is absolute
    if url && !url.start_with?('http://', 'https://', 'mailto:')
      url = "https://www.uni-kiel.de" + url
    end
    
    # Append the job posting to the list if it contains all necessary information
    if name && description && url
      job_postings << { name: name, description: description, url: url }
    end
  end
  
  job_postings
end