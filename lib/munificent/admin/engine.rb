require "munificent"

require "authlogic" # This activates AuthLogic's controller code
require "cancan" # This activates CanCan's controller code
require "dartsass-rails"

module Munificent
  module Admin
    class Engine < ::Rails::Engine
      isolate_namespace Munificent::Admin

      initializer "munificent-admin.importmap", before: "importmap" do |app|
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
      end

      initializer "munificent-admin.dartsass" do |app|
        app.config.dartsass.builds["munificent-admin.scss"] = "munificent-admin.css"
      end

      initializer "munificent-admin.assets" do |app|
        app.config.assets.precompile += %w[munificent_admin_manifest]
      end

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot
        g.factory_bot dir: "test/factories"
      end
    end
  end
end
