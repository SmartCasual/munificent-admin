require "bundler/setup"

APP_RAKEFILE = File.expand_path("test/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

require "bundler/gem_tasks"

load "tasks/munificent/default.rake"
load "tasks/munificent/cucumber.rake"
load "tasks/munificent/admin_tasks.rake"
