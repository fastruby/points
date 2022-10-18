require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
end
