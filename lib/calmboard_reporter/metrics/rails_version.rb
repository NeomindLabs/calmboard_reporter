module CalmboardReporter
  module Metrics
    class RailsVersion
      def self.check
        Rails.version
      end
    end
  end
end
