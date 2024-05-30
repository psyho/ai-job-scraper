require_relative "constants"
require_relative "parser"
require_relative "simple_downloader"
require_relative "dynamic_downloader"
require_relative "tracing"

require "json"
require "parallel"

Site = Data.define(:url, :idx, :no_js) do
  def self.all
    sites = JSON.parse(METADATA_FILE.read, symbolize_names: true)

    sites.map do |url, data|
      new(url: url.to_s, idx: data[:idx], no_js: data[:no_js])
    end
  end

  def self.fetch_all_listings
    context = OpenTelemetry::Context.current

    Parallel.flat_map(Site.all, in_threads: THREAD_COUNT) do |site|
      span = TRACER.start_span("fetch_listings", with_parent: context)
      OpenTelemetry::Trace.with_span(span) do
        span.set_attribute("site_url", site.url)
        listings = site.fetch_listings
        span.set_attribute("listings_count", listings.size)
        listings
      end
    end
  end

  def parser
    Parser.for_site(self)
  end

  def downloader
    js? ? DynamicDownloader.new : SimpleDownloader.new
  end

  def fetch_listings
    downloader.fetch_listings(url, parser)
  end

  def js? = !no_js

  def no_js? = no_js
end
