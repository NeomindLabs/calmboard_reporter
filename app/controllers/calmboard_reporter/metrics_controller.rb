require_dependency "calmboard_reporter/encryption"

module CalmboardReporter
  class MetricsController < ActionController::Base
    def show
      metrics = Metrics::Base.check_all
      encrypted_metrics = CalmboardReporter::Encryption.encrypt(metrics.to_json)
      render json: {encrypted_metrics: encrypted_metrics}, status: :ok
    rescue => e
      render json: {error: e.message}, status: :unprocessable_entity
    end
  end
end
