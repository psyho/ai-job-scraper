require_relative "constants"
require_relative "tracing"

require "faraday"
require "faraday/follow_redirects"

class SimpleDownloader
  include Tracing

  def fetch_listings(url, parser, tries = 3)
    active_span.add_field("tries", tries)
    active_span.add_field("url", url)

    if tries <= 0
      LOGGER.error("Failed to fetch listings from #{url} after 3 tries")
      active_span.add_field("tries_exceeded", true)
      return []
    end

    LOGGER.info("Fetching listings from #{url}")
    html = fetch(url)
    listings = parser.parse(html)
    LOGGER.info("Fetched #{listings.size} listings from #{url}")
    active_span.add_field("listings_count", listings.size)
    listings
  rescue StandardError => e
    LOGGER.warn("Failed to fetch listings from #{url}: #{e.message}\n#{e.backtrace.join("\n")}")
    Tracing.record_exception(e)
    fetch_listings(url, parser, tries - 1)
  end
  span :fetch_listings

  private

  def fetch(url)
    faraday = Faraday.new do |cfg|
      cfg.response :follow_redirects
      cfg.adapter Faraday.default_adapter
    end

    response = faraday.get(url)

    fix_encoding(response.body)
  end

  def fix_encoding(str)
    str.encode('utf-8')
  rescue Encoding::UndefinedConversionError
    str.force_encoding('iso-8859-1').encode('utf-8')
  end
end
