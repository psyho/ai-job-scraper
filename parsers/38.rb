def parse_job_postings(html)
  # Base URL for absolute paths
  base_url = "https://www.uni-leipzig.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all article elements with class 'searchresult'
  articles = doc.css('.searchresult')
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Iterate over each article to extract job details
  articles.each do |article|
    # Extract the job title from the h3 tag within the header
    title = article.at_css('header h3').text.strip if article.at_css('header h3')
    
    # Extract the description from the p tag within the header
    description = article.at_css('header p.subline-teaser').text.strip if article.at_css('header p.subline-teaser')
    
    # Extract the URL from the 'a' tag within the footer
    link = article.at_css('footer a')['href'] if article.at_css('footer a')
    link = base_url + link if link && !link.start_with?('http')
    
    # Only add the job posting if it has both a title and a URL
    if title && link
      job_postings << {
        name: title,
        description: description,
        url: link
      }
    end
  end
  
  # Return the array of job postings
  job_postings
end