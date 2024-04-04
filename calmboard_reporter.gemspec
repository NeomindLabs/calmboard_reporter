require_relative "lib/calmboard_reporter/version"

Gem::Specification.new do |spec|
  spec.name = "calmboard_reporter"
  spec.version = CalmboardReporter::VERSION
  spec.authors = ["Greg Matthew Crossley"]
  spec.email = ["greg@neomindlabs.com"]
  spec.homepage = "https://github.com/NeomindLabs/calmboard_reporter"
  spec.summary = "A Rails engine that serves encrypted reports about your app for Calmboard."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 4.2"

  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "rspec-rails", "~> 5.0"
end
