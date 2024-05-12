def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all div elements with class 'teaser2'
  postings = doc.css('div.teaser2')
  
  # Initialize an array to store the job postings
  job_postings = []
  
  # Iterate over each posting
  postings.each do |posting|
    # Extract the name from the h3 tag
    name = posting.at_css('h3').text.strip
    
    # Extract the description from the p tags, excluding the last one which contains the link text "[ mehr ... ]"
    description_elements = posting.css('p')
    description = description_elements[0...-1].map(&:text).join(' ').strip.gsub("\n", " ")
    
    # Extract the URL from the 'a' tag with class 'mehr'
    url_element = posting.at_css('a.mehr')
    next unless url_element  # Skip if no URL is found
    
    url = url_element['href'].strip
    
    # Store the extracted data in a hash and push it to the job_postings array
    job_postings << { name: name, description: description, url: url }
  end
  
  # Return the array of job postings
  job_postings
end