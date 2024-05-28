require "pathname"
require "logger"

PARSERS_DIR = Pathname(File.expand_path("../parsers", __dir__))
METADATA_FILE = Pathname(File.expand_path("../metadata.json", __dir__))
LOGGER = Logger.new($stderr)