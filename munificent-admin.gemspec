require_relative "lib/munificent/admin/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.1"

  spec.name        = "munificent-admin"
  spec.version     = Munificent::Admin::VERSION
  spec.authors     = ["Elliot Crosby-McCullough"]
  spec.email       = ["elliot@smart-casual.com"]
  spec.homepage    = "https://github.com/SmartCasual/munificent-admin"
  spec.summary     = "The admin section of Munificent"
  spec.license     = "CC-BY-NC-SA-4.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/#{spec.version}/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(File.expand_path(__dir__)) {
    Dir["{app,config,db,lib}/**/*", "LICENCE", "Rakefile", "README.md"]
  }

  spec.add_dependency "authlogic", "~> 6.4"
  spec.add_dependency "cancancan", "~> 3.2"
  spec.add_dependency "dartsass-rails", "~> 0.3"
  spec.add_dependency "importmap-rails", "~> 1.1"
  spec.add_dependency "monetize", "~> 1.12"
  spec.add_dependency "money-rails", "~> 1.15"
  spec.add_dependency "munificent", "~> 2.0"
  spec.add_dependency "net-smtp", "~> 0.3"
  spec.add_dependency "rails", ">= 7.0.3"
  spec.add_dependency "redis", "~> 4.6"
  spec.add_dependency "rollbar", "~> 3.3"
  spec.add_dependency "rotp", "~> 6.2"
  spec.add_dependency "rqrcode", "~> 2.1"
  spec.add_dependency "scrypt", "~> 3.0"
  spec.add_dependency "sprockets-rails", "~> 3.4"
end
