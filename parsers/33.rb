def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Find all 'ul' elements with class 'stellenliste'
  doc.css('ul.stellenliste').each do |ul|
    # Iterate over each 'li' element within the 'ul'
    ul.css('li').each do |li|
      # Extract the job title and URL
      title_element = li.at_css('a')
      next unless title_element  # Skip if no link is found
      
      title = title_element.text.strip
      url = title_element['href']
      
      # Ensure URL is absolute
      if url && !url.start_with?('http', 'https')
        url = "https://uol.de#{url}" unless url.start_with?('/')
      end
      
      # Extract the description (typically the department or faculty)
      description_element = li.at_css('.einrichtung')
      description = description_element ? description_element.text.strip : ""
      
      # Store the job posting information in a hash and add it to the array
      job_postings << {
        name: title,
        description: description,
        url: url
      }
    end
  end
  
  job_postings
end