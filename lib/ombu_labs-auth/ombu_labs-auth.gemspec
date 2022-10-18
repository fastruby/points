require_relative "lib/ombu_labs/auth/version"

Gem::Specification.new do |spec|
  spec.name        = "ombu_labs-auth"
  spec.version     = OmbuLabs::Auth::VERSION
  spec.authors     = ["Ombulabs"]
  spec.email       = ["hello@ombulabs.com"]
  # spec.homepage    = "TODO"
  spec.summary     = "Ombulabs internal authentication gem"
  # spec.description = "TODO: Description of OmbuLabs::Auth."
  spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "~> 7.0.2"
  spec.add_dependency "devise", "~> 4.8.1"
  spec.add_dependency "omniauth", "~> 2.1.0"
  spec.add_dependency "omniauth-github", "~> 2.0.0"
end
