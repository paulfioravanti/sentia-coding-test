# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "activerecord-pg_enum", "~> 1.2"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false
gem "draper", "~> 4.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
gem "kaminari", "~> 1.2"
# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 6.1.0"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Turbolinks makes navigating your web application faster.
# Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", "~> 2.0.4", platforms: %i[mingw mswin x64_mingw jruby]
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "pry-byebug", "~> 3.9"
end

group :development do
  # Help to kill N+1 queries and unused eager loading
  gem "bullet", "~> 6.1"
  gem "listen", "~> 3.3"
  # Display performance information such as SQL time and flame graphs for each
  # request in your browser.
  # Can be configured to work on production as well see:
  # https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem "rack-mini-profiler", "~> 2.0"
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem "spring", "~> 2.1.1"
  # Access an interactive console on exception pages or by calling "console"
  # anywhere in the code.
  gem "web-console", ">= 4.1.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", "~> 3.142.7"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers", "~> 4.6.0"
end
