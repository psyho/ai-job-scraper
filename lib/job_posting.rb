require "json"
require "dry-equalizer"

require_relative "constants"
require_relative "tracing"

JobPosting = Data.define(:name, :description, :url, :site_url, :downloaded_at) do
  include Comparable
  include Dry::Equalizer(:key)
  include Tracing

  def self.load_db(db_file)
    unless File.exist?(db_file)
      active_span.set_attribute("db_file.exists", false)
      return []
    end

    active_span.set_attribute("db_file.exists", true)
    File.open(db_file, "r") do |f|
      postings = JSON.load(f).map do |attrs|
        new(
          name: attrs["name"],
          description: attrs["description"],
          url: attrs["url"],
          site_url: attrs["site_url"],
          downloaded_at: Time.parse(attrs["downloaded_at"])
        )
      end

      active_span.set_attribute("job_postings.count", postings.size)
      postings
    end
  end
  class_span :load_db

  def self.save_db(db_file, job_postings)
    active_span.set_attribute("job_postings.count", job_postings.size)
    File.write(db_file, JSON.pretty_generate(job_postings.map(&:to_h)))
  end
  class_span :save_db

  def key
    [name, description, url, site_url].join("--")
  end

  def <=>(other)
    return unless other.is_a?(self.class)

    key <=> other.key
  end

  def keyword_match?
    "#{name} #{description}".match?(KEYWORDS)
  end
end
