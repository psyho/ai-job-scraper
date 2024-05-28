def parse_job_postings(html)
  doc = Nokogiri::HTML(html)
  job_postings = []

  doc.css('dl.ubf-accordion dt.ubf-accordion__toggler').each do |department_section|
    department_name = department_section.css('a.ubf-accordion__togglerLink span.ubf-accordion__togglerLabel').text.strip
    department_section.next_element.css('ul li').each do |job_item|
      job_link = job_item.css('a').first
      next unless job_link && job_link['href'].include?('/uni/karriere/professuren/')

      job_postings << {
        name: job_link.text.strip,
        description: department_name,
        url: URI.join("https://www.uni-bielefeld.de", job_link['href']).to_s
      }
    end
  end

  job_postings
end