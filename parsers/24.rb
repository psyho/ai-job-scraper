def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_listings = []

  doc.css('.joboffers-block .bite-jobs-list tr.bite-jobs-list--row').each do |row|
    job_title = row.at_css('.bite-jobs-list--title').text.strip
    department = row.at_css('.bite-jobs-list--fakultaet').text.strip
    application_deadline = row.at_css('.bite-jobs-list--bewerbungsfrist').text.strip

    # Construct the URL for the job posting
    job_url = "https://www.lmu.de/de/die-lmu/arbeiten-an-der-lmu/stellenportal/professuren/"

    # Filter out rows that are not actual job postings
    next if job_title.empty? || department.empty? || application_deadline.empty?

    job_listings << {
      name: job_title,
      description: "Department: #{department}, Application Deadline: #{application_deadline}",
      url: job_url
    }
  end

  job_listings
end