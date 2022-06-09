source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in munificent-admin.gemspec.
gemspec

gem "byebug", "~> 11.1", platforms: %i[mri mingw x64_mingw]
gem "importmap-rails", "~> 1.1"
gem "munificent", path: "../munificent"
gem "pg", "~> 1.3"
gem "puma", "~> 5.6"
gem "rubocop", "~> 1.25"
gem "rubocop-rails", "~> 2.13"
gem "rubocop-rake", "~> 0.6"
gem "rubocop-rspec", "~> 2.7"
gem "sass-rails", ">= 6"
gem "sprockets-rails"

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0", require: false
  gem "spring", "~> 4.0"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "climate_control", "~> 1.0"
  gem "cucumber-rails", "~> 2.5", require: false
  gem "database_cleaner", "~> 2.0"
  gem "factory_bot", "~> 6.2"
  gem "factory_bot_namespaced_factories", "~> 0.1"
  gem "factory_bot_rails", "~> 6.2"
  gem "launchy", "~> 2.5"
  gem "rspec-rails", "~> 5.0"
  gem "selenium-webdriver", "~> 4.1"
  gem "timecop", "~> 0.9"
  gem "vcr", "~> 6.1"
  gem "watir", "~> 7.1"
  gem "webdrivers", "~> 5.0", require: false
  gem "webmock", "~> 3.14"
end
