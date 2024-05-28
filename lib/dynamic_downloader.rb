require_relative "constants"

require "watir"

class DynamicDownloader
  def initialize(timeout = 60)
    @timeout = timeout
    @browser = Watir::Browser.new(:chrome, headless: true)
    @url = nil
  end

  def fetch_listings(url, parser)
    LOGGER.info("Fetching listings from #{url}")

    html = fetch(url)
    listings = try_parse(html, parser)
    elapsed = 0

    while listings.empty? && elapsed < @timeout
      LOGGER.info("No listings found for #{url}. Retrying in 1 second. Elapsed time: #{elapsed} seconds.")
      sleep(1)
      elapsed += 1
      html = fetch(url)
      listings = try_parse(html, parser)
    end

    close

    LOGGER.info("Found #{listings.size} listings for #{url}")

    listings
  end

  private

  def fetch(url)
    if @url != url
      @browser.goto(url)
      @url = url
    end

    @browser.html
  end


  def close
    @browser.close
    @url = nil
  end

  def try_parse(html, parser)
    parser.parse(html)
  rescue => e
    LOGGER.warn("Error parsing HTML: #{e.message}", e)
    []
  end
end
