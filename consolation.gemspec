$:.push File.expand_path("../lib", __FILE__)

require "consolation/version"

Gem::Specification.new do |s|
  s.name        = "consolation"
  s.version     = Consolation::VERSION
  s.authors     = ["Jake Cataford"]
  s.email       = ["JakeCataford@gmail.com"]
  s.homepage    = "http://github.com/JakeCataford/Consolation"
  s.summary     = "A terminal widget for rails views."
  s.description = "Add styled and ansi color escaped terminal output to your rails views."

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.4"
  s.add_dependency "jquery-rails"
  s.add_dependency "zeroclipboard-rails"

  s.add_development_dependency "sqlite3"
end
