module CalmboardReporter
  module Metrics
    class RubyVersion
      def self.check
        RUBY_VERSION
      end
    end
  end
end
