module CalmboardReporter
  module Metrics
    class Base
      def self.check_all
        metrics = {}
        metric_modules.each do |metric_module|
          metric_name = metric_module.name.split("::").last.underscore
          metrics[metric_name] = metric_module.check
        end
        metrics
      end

      def self.metric_modules
        CalmboardReporter::Metrics.constants.select do |constant_name|
          constant = CalmboardReporter::Metrics.const_get(constant_name)
          constant.is_a?(Class) && constant.respond_to?(:check)
        end.map { |name| CalmboardReporter::Metrics.const_get(name) }
      end
    end
  end
end
