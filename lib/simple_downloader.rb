require_relative "constants"

require "faraday"
require "faraday/follow_redirects"

class SimpleDownloader
  def fetch_listings(url, parser)
    LOGGER.info("Fetching listings from #{url}")
    html = fetch(url)
    listings = parser.parse(html)
    LOGGER.info("Fetched #{listings.size} listings from #{url}")
    listings
  end

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
