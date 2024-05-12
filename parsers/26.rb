def parse_job_postings(html)
  require 'nokogiri'
  
  # Parse the HTML content
  doc = Nokogiri::HTML(html)
  
  # Find the table with class 'line' and iterate over its rows
  job_postings = []
  doc.css('table.line tr').each_with_index do |row, index|
    # Skip the header row
    next if index == 0
    
    # Extract job details from the row
    cells = row.css('td')
    next if cells.empty? || cells[0].css('a').empty?
    
    # Extracting job name and URL
    job_name_links = cells[0].css('a')
    job_names = job_name_links.map(&:text).join(' / ')
    job_urls = job_name_links.map { |link| link['href'] }.join(' / ')
    
    # Ensure URLs are absolute
    job_urls = job_urls.split(' / ').map do |url|
      url.start_with?('http') ? url : "https://www.uni-giessen.de#{url}"
    end.join(' / ')
    
    # Extracting the organization area (description)
    organization_area = cells[2].text.strip
    
    # Ensure that the description is not empty or generic
    next if organization_area.empty? || organization_area == 'Organisationsbereich'
    
    job_postings << {
      name: job_names,
      description: organization_area,
      url: job_urls
    }
  end
  
  job_postings
end