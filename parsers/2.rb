def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the job listings container
  job_listings = doc.css('dl.jobListing')
  
  # Initialize an array to store job postings
  jobs = []
  
  # Iterate over each job listing
  job_listings.each do |listing|
    # Each job is contained within <dd> tags
    listing.css('dd').each do |job|
      # Extract job name and URL
      job_name = job.at_css('a').text.strip
      job_url = job.at_css('a')['href']
      
      # Extract additional details like department and deadline
      department = job.css('p strong').first.text.strip rescue nil
      deadline = job.css('small span').last.text.strip rescue nil
      
      # Construct a hash for the job and add it to the jobs array
      jobs << {
        name: job_name,
        description: "#{department}, Bewerbung bis: #{deadline}",
        url: job_url
      }
    end
  end
  
  # Filter out entries that do not seem to be job postings (e.g., missing crucial information)
  jobs.select! do |job|
    job[:name] != "" && job[:url].include?("stellenausschreibungen") && job[:description].include?("Bewerbung bis:")
  end
  
  jobs
end