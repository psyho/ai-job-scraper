require_relative "constants"
require_relative "job_posting"

class Parser
  NotFoundError = Class.new(StandardError)

  def self.for_site(site)
    file = PARSERS_DIR.join("#{site.idx}.rb")
    raise NotFoundError, "Parser not found for index #{site.idx}" unless file.exist?

    parser = Object.new
    parser.instance_eval(file.read, file.to_s, 1)

    new(parser, site.url)
  end

  def initialize(parser_object, site_url)
    @parser_object = parser_object
    @site_url = site_url
  end

  def parse(html)
    try_parse(html).map do |hash|
      JobPosting.new(name: hash[:name],
                     description: hash[:description],
                     url: hash[:url],
                     site_url: @site_url,
                     downloaded_at: Time.now)
    end
  end

  private

  def try_parse(html)
    @parser_object.parse_job_postings(html)
  rescue StandardError => e
    LOGGER.error("Error parsing job postings: #{e.message} #{e.backtrace.join("\n")}")
    []
  end
end
