
def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  base_url = "https://www.uni-flensburg.de"

  doc.css('.jobWrapper-block').each do |block|
    block.css('.bite_entry').each do |entry|
      job_title = entry.at_css('.bite_entry--title')&.text&.strip
      application_deadline = entry.at_css('.bite_entry--endsOn')&.text&.strip
      description = "Application Deadline: #{application_deadline}"

      # Since the URLs are not provided in the HTML, we will skip the URL part
      job_postings << { name: job_title, description: description, url: nil }
    end
  end

  job_postings
end