# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"

require "byebug"
require "factory_bot"
require "factory_bot_rails"
require "munificent"
FactoryBot.find_definitions

ENV["RAILS_ENV"] ||= "test"
ENV["OTP_ISSUER"] = "Munificent admin (test)"
ENV["RAILS_ROOT"] = File.expand_path("test/dummy", __dir__)

require File.expand_path("../test/dummy/config/environment", __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

require_relative "../test/support/with_env"

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

ENV["KMS_KEY_ID"] = "insecure-test-key"
ENV["BLIND_INDEX_MASTER_KEY"] = "0" * 64

RSpec.configure do |config|
  config.include WithEnv

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe Admin::UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before do
    ActionMailer::Base.deliveries.clear
  end

  config.include FactoryBot::Syntax::Methods
end
