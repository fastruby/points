require_relative "boot"

require "rails-observers"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Points
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Do not use the SassC/libsass CSS compressor: it re-parses already-compiled
    # CSS and evaluates arithmetic inside calc()/min() (e.g. `100vh - 160px`),
    # raising "Incompatible units" on valid CSS. Set to nil explicitly since
    # sprockets-rails otherwise defaults to :sass when sassc is available. This
    # affects any env that compiles assets (test + production), so set it here.
    config.assets.css_compressor = nil
  end
end
