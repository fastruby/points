source "https://rubygems.org"

ruby "3.1.0"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 7.0.2"
gem "devise"
gem "bootstrap-sass", "3.4.1"
gem "puma", "~> 4.3"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "bourbon"
gem "matrix"
gem "redcarpet", "~> 3.5.1"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "pg", "~> 1.1"
gem "jquery-ui-rails", "~> 5.0", ">= 5.0.5"
gem "acts_as_list"
gem "mimemagic", "~> 0.3.8"
gem "omniauth-github", "~> 2.0.0"
gem "omniauth-rails_csrf_protection"
gem "rack-mini-profiler"
gem "coffee-script"
gem "pundit", "~> 2.2"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
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
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.7"
  gem "spring", "3.0.0"
  gem "standardrb", require: false
end

group :development, :test do
  gem "next_rails"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
