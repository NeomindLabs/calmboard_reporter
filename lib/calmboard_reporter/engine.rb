module CalmboardReporter
  class Engine < ::Rails::Engine
    isolate_namespace CalmboardReporter

    initializer "calmboard_reporter.add_middleware" do |app|
      app.routes.prepend do
        get "/calmboard_reporter" => "calmboard_reporter/metrics#show"
      end
    end
  end
end
