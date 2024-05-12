def parse_job_postings(html)
  require 'nokogiri'
  
  # Base URL of the website, assuming URLs need to be absolute
  base_url = "https://www.uni-flensburg.de"
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find all job posting blocks
  job_blocks = doc.css('.jobWrapper-block')
  
  # Initialize an array to store job postings
  job_postings = []
  
  # Iterate over each job block
  job_blocks.each do |block|
    # Get the category of the jobs from the h2 tag
    category = block.at_css('h2')&.text&.strip
    
    # Iterate over each job entry within the block
    block.css('.bite_entry').each do |entry|
      # Extract job title and deadline from the entry
      title = entry.at_css('.bite_entry--title')&.text&.strip
      ends_on = entry.at_css('.bite_entry--endsOn')&.text&.strip
      
      # Construct the job posting hash
      job_posting = {
        name: title,
        description: "#{category} - #{ends_on}",
        url: nil  # Hypothetical URL handling
      }
      
      # If URLs were present, process them to ensure they are absolute
      if entry['href']
        job_posting[:url] = entry['href'].start_with?('http') ? entry['href'] : "#{base_url}#{entry['href']}"
      end
      
      # Add the job posting to the list
      job_postings << job_posting
    end
  end
  
  # Return the list of job postings
  job_postings
end