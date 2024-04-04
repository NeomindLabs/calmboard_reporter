Rails.application.routes.draw do
  mount CalmboardReporter::Engine => "/calmboard_reporter"
end
