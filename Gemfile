source "https://rubygems.org"

def next?
  File.basename(__FILE__) == "Gemfile.next"
end

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

if next?
  gem "rails", "~> 6.0.3.4"
else
  gem "rails", "~> 5.2.3"
end
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'

gem "bootstrap-sass", "3.4.1"

gem "devise", git: "https://github.com/heartcombo/devise.git", ref: "8bb358cf80a632d3232c3f548ce7b95fd94b6eb2"

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem "puma", "~> 4.3"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

if next?
  gem "bourbon"
else
  gem "bourbon", git: "https://github.com/thoughtbot/bourbon.git",
                 tag: "v5.0.0.beta.6"
end

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
gem "pg", "~> 0.18"
gem "jquery-ui-rails", "~> 5.0", ">= 5.0.5"
gem "acts_as_list"

gem 'mimemagic', '~> 0.3.8'

if next?
  gem "omniauth-github", "~> 2.0.0"
else
  gem "omniauth-github"
end
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
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "standardrb"
end

group :development, :test do
  gem "next_rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "coffee-script"
