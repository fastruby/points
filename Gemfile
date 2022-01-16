source "https://rubygems.org"

def next?
  File.basename(__FILE__) == "Gemfile.next"
end

ruby "3.0.2"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

if next?
  gem "rails", github: "rails/rails", branch: "main"
  gem "devise", github: "heartcombo/devise", branch: "main"
else
  gem "rails", "~> 7.0.0"
  gem "devise"
end
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem "bootstrap-sass", "3.4.1"

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem "puma", "~> 4.3"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

gem "bourbon"

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem "redcarpet", "~> 3.5.1"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem "jquery-rails"

gem "pg", "~> 1.1"

gem "jquery-ui-rails", "~> 5.0", ">= 5.0.5"
gem "acts_as_list"

gem "mimemagic", "~> 0.3.8"

gem "omniauth-github", "~> 2.0.0"
gem "omniauth-rails_csrf_protection"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "rspec-rails", "~> 4.0.2"
  gem "faker"
  gem "shoulda-matchers", "~> 3.1"
  gem "rails-controller-testing"
  gem "dotenv-rails"
  gem "recursive-open-struct"
  gem "factory_bot_rails"
end

group :test do
  gem "apparition", git: "https://github.com/twalpole/apparition.git", ref: "7db58cc6b0e4ca4141b074ff27d5936a1b8874bf"
  gem "capybara"
  gem "webdrivers"
  gem "database_cleaner"
  gem "capybara-screenshot"
  gem "simplecov", require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.7"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "standardrb", require: false
end

group :development, :test do
  gem "next_rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "coffee-script"
