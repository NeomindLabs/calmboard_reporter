require "calmboard_reporter/version"
require "calmboard_reporter/engine"

# Require all the metrics modules
Dir[File.join(__dir__, "calmboard_reporter/metrics/*.rb")].each { |file| require file }

module CalmboardReporter
  # Your code goes here...
end
