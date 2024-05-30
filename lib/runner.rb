require_relative '../lib/site'
require_relative '../lib/job_posting'
require_relative '../lib/new_jobs_email'
require_relative '../lib/constants'
require_relative '../lib/tracing'

class Runner
  include Tracing

  attr_reader :db_file

  def initialize(db_file)
    @db_file = db_file
  end

  def run
    job_postings = JobPosting.load_db(db_file).to_set
    LOGGER.info "Jobs in DB: #{job_postings.size}"
    active_span.add_field('jobs_in_db', job_postings.size)

    downloaded_job_postings = Site.fetch_all_listings.to_set
    LOGGER.info "Jobs downloaded: #{downloaded_job_postings.size}"
    active_span.add_field('jobs_downloaded', downloaded_job_postings.size)

    new_job_postings = downloaded_job_postings - job_postings
    LOGGER.info "New Jobs: #{new_job_postings.size}"
    active_span.add_field('new_jobs', new_job_postings.size)

    JobPosting.save_db(db_file, (job_postings + new_job_postings).to_a)

    new_matching_job_postings = new_job_postings.select(&:keyword_match?)
    active_span.add_field('new_matching_jobs', new_matching_job_postings.size)

    if new_matching_job_postings.empty?
      LOGGER.info("No new matching jobs")
      exit 0
    end

    new_matching_job_postings.each do |job_posting|
      LOGGER.info("New matching job: #{job_posting.name} - #{job_posting.description} - #{job_posting.url} from site: #{job_posting.site_url}")
    end

    new_jobs_by_site = new_matching_job_postings.group_by(&:site_url).to_h

    new_jobs_by_site.each do |site_url, jobs|
      Tracing.start_span("new_jobs") do |span|
        span.add_field("site_url", site_url)
        span.add_field("count", jobs.size)
      end
    end

    NewJobsEmail.deliver(new_jobs_by_site)
  end
  span :run
end
