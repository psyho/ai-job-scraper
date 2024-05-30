require "dotenv/load"

require_relative 'lib/runner'
require_relative 'lib/tracing'

desc "Run the job scraping process"
task :run do
  db_file = ENV.fetch("DB_FILE", "db.json")
  Runner.new(db_file).run
end
