def parse_job_postings(html)
  require 'nokogiri'
  require 'uri'
  
  # Base URL for constructing absolute URLs
  base_url = "https://www.uni-osnabrueck.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Initialize an empty array to store job postings
  job_postings = []
  
  # Select all <p> elements that contain a link to a job detail page
  doc.css('div.eb2 p').each do |p_element|
    # Extract the <a> element
    a_element = p_element.at_css('a')
    next unless a_element && !a_element.text.strip.empty?
    
    # Extract job name and URL
    job_name = a_element.text.strip
    job_url = URI.join(base_url, a_element['href']).to_s
    
    # Extract the description which is the content of the <p> tag excluding the <a> tag
    description = p_element.text.gsub(job_name, '').strip
    description = description.sub(/^,/, '').strip  # Remove leading comma and extra spaces
    
    # Append the job posting to the list if it contains essential information
    if job_name.length > 0 && description.length > 0
      job_postings << {
        name: job_name,
        description: description,
        url: job_url
      }
    end
  end
  
  job_postings
end