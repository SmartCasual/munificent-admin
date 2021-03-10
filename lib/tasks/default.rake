begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => exception
  puts "Library not available: #{exception.message}"
end

desc "Build, lint, and test"
task :build_and_test do
  Rake::Task["lint"].invoke
  Rake::Task["test"].invoke
  Rake::Task["build"].invoke unless ENV["CI"]
end

desc "Lint"
task :lint do
  # TODO: Add rubocop
end

desc "Test"
task :test do
  Rake::Task["spec"].invoke
  Rake::Task["cucumber"].invoke
end

desc "Build"
task :build do
  # no-op
end

task default: :build_and_test
