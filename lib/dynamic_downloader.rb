require_relative "constants"
require_relative "tracing"

require "watir"

class DynamicDownloader
  include Tracing

  def initialize(timeout = DOWNLOAD_TIMEOUT, sleep_time = SLEEP_TIME)
    @timeout = timeout
    @sleep_time = sleep_time
    @url = nil
  end

  def fetch_listings(url, parser, tries = 3)
    LOGGER.info("Fetching listings from #{url}")

    active_span.set_attribute("url", url)
    active_span.set_attribute("tries", tries)

    if tries <= 0
      LOGGER.error("Failed to fetch listings for #{url} after 3 tries. Bailing out!")
      active_span.set_attribute("tries_exceeded", true)
      return []
    end

    html = fetch(url)
    listings = try_parse(html, parser)
    elapsed = 0

    while listings.empty? && elapsed < @timeout
      LOGGER.info("No listings found for #{url}. Retrying in #{@sleep_time} seconds. Elapsed time: #{elapsed} seconds.")
      sleep(@sleep_time)
      elapsed += @sleep_time
      html = fetch(url)
      listings = try_parse(html, parser)
    end

    active_span.set_attribute("listings_count", listings.size)
    active_span.set_attribute("elapsed_time", elapsed)

    LOGGER.info("Found #{listings.size} listings for #{url}")

    listings
  rescue StandardError => e
    LOGGER.warn("Error fetching listings for #{url}: #{e.message}\n#{e.backtrace.join("\n")}")
    active_span.record_exception(e)
    fetch_listings(url, parser, tries - 1)
  ensure
    close
  end

  private

  def fetch(url)
    if @url != url
      @browser = Watir::Browser.new(:chrome, headless: true)
      @browser.goto(url)
      @url = url
    end

    @browser.html
  end


  def close
    @browser.close if @browser
    @browser = nil
    @url = nil
  end

  def try_parse(html, parser)
    parser.parse(html)
  rescue => e
    LOGGER.warn("Error parsing HTML: #{e.message}", e)
    []
  end
end
