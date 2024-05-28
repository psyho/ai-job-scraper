require "json"
require "dry-equalizer"

require_relative "constants"

JobPosting = Data.define(:name, :description, :url, :site_url, :downloaded_at) do
  include Comparable
  include Dry::Equalizer(:key)

  def self.load_db(db_file)
    return [] unless File.exist?(db_file)

    File.open(db_file, "r") do |f|
      JSON.load(f).map do |attrs|
        new(
          name: attrs["name"],
          description: attrs["description"],
          url: attrs["url"],
          site_url: attrs["site_url"],
          downloaded_at: Time.parse(attrs["downloaded_at"])
        )
      end
    end
  end

  def self.save_db(db_file, job_postings)
    File.write(db_file, JSON.pretty_generate(job_postings.map(&:to_h)))
  end

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
