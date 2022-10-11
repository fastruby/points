# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "capybara/rspec"
# Add additional requires below this line. Rails is not loaded until this point!

# When updating Capybara check if we still need this, newer versions already include this config
# https://github.com/teamcapybara/capybara/blob/c7c22789b7aaf6c1515bf6e68f00bfe074cf8fc1/lib/capybara/registrations/drivers.rb
Capybara.register_driver :headless_firefox do |app|
  browser_options = ::Selenium::WebDriver::Firefox::Options.new
  browser_options.args << "-headless"
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: browser_options)
end
Capybara.javascript_driver = :headless_firefox
Capybara.server = :puma, {Silent: true}

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

require "deprecation_tracker"

module FeatureSpecsHelpers
  def set_estimates(best, worst)
    select best.to_s, from: "estimate[best_case_points]"
    select worst.to_s, from: "estimate[worst_case_points]"
  end

  def within_story_row(story, &block)
    within "#story_#{story.id}" do
      yield
    end
  end

  def within_modal(&block)
    within ".modal.in" do
      yield
    end
  end

  def expect_closed_modal
    expect(page).to have_selector ".modal.in", count: 0
  end

  def expect_story_estimates(story, best, worst)
    within_story_row(story) do
      expect(find("td:nth-child(2)")).to have_text best.to_s
      expect(find("td:nth-child(3)")).to have_text worst.to_s
    end
  end
end

# TODO: remove when rspec-rails is fixed for Rails 7
# This PR in the main Rails branch https://github.com/rails/rails/pull/43734
# added a call to the `executor_around_each_request` method
# that it's not yet supported in RSpec
# After updating RSpec when Rails 7 is released we will probably be able
# to delete this
module RSpec::Rails::RailsExampleGroup
  def executor_around_each_request
    true
  end
end

RSpec.configure do |config|
  include Warden::Test::Helpers

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include FeatureSpecsHelpers, type: :feature

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
