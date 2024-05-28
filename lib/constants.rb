require "pathname"
require "logger"

PARSERS_DIR = Pathname(File.expand_path("../parsers", __dir__))
METADATA_FILE = Pathname(File.expand_path("../metadata.json", __dir__))
KEYWORDS = /(?i)(Geschichte|history|Historiker|Heritage)/m
THREAD_COUNT = ENV.fetch("THREAD_COUNT", 8).to_i
DOWNLOAD_TIMEOUT = ENV.fetch("DOWNLOAD_TIMEOUT", 30).to_f
SLEEP_TIME = ENV.fetch("SLEEP_TIME", 1).to_f
LOGGER = Logger.new($stderr)