require_relative "constants"
require_relative "job_posting"
require_relative "tracing"

require "nokogiri"

class Parser
  include Tracing

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
      JobPosting.new(name: hash[:name].to_s,
                     description: hash[:description].to_s,
                     url: (hash[:url] || @site_url).to_s,
                     site_url: @site_url,
                     downloaded_at: Time.now)
    end
  end
  span :parse

  private

  def try_parse(html)
    @parser_object.parse_job_postings(html)
  rescue StandardError => e
    LOGGER.error("Error parsing job postings: #{e.message} #{e.backtrace.join("\n")}")
    active_span.record_exception(e)
    []
  end
end
