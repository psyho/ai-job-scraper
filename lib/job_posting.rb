JobPosting = Data.define(:name, :description, :url, :site_url, :downloaded_at) do
  include Comparable

  def <=>(other)
    return unless other.is_a?(self.class)

    [name, description, url, site_url] <=> [other.name, other.description, other.url, other.site_url]
  end
end
