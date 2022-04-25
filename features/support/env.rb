# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

ENV["OTP_ISSUER"] = "Jingle Jam (test)"
ENV["TWITCH_EMBED_ENABLED"] = "false"

require "cucumber/rails"

require "webdrivers"
require "webdrivers/chromedriver"

require "webmock/cucumber"
driver_urls = Webdrivers::Common.subclasses.map(&:base_url)
WebMock.disable_net_connect!(allow_localhost: true, allow: driver_urls)

require "rspec/mocks"
require "cucumber/rspec/doubles"

FactoryBot.find_definitions
World(FactoryBot::Syntax::Methods)

require "sidekiq/testing"
Sidekiq::Testing.inline!

require_relative "../../test/support/with_env"
World(WithEnv)

require_relative "../../test/support/stripe_test_helpers"
World(StripeTestHelpers)

require_relative "../../test/support/test_data"

Around do |_, block|
  TestData.clear
  block.call
  TestData.clear
end

Before("not @real_payment_providers") do
  TestData[:fake_payment_providers] = true
end

Around("@real_payment_providers") do |_, block|
  WebMock.disable!
  block.call
  WebMock.enable!
end

TEST_PORT = 30_001

Capybara.configure do |config|
  config.server = :puma, { Silent: true }
  config.server_port = TEST_PORT
end

ActionMailer::Base.default_url_options[:port] = TEST_PORT

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Before do
  if page.driver.browser.respond_to?(:manage)
    page.driver.browser.manage.window.maximize
  end
end

After do
  ::RSpec::Mocks.verify
ensure
  ::RSpec::Mocks.teardown
end

Around("@twitch_embed_enabled") do |_, scenario|
  with_env("TWITCH_EMBED_ENABLED" => "true") do
    scenario.call
  end
end
