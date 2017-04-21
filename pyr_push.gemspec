$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pyr/push/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pyr_push"
  s.version     = Pyr::Push::VERSION
  s.authors     = ["John Cwikla"]
  s.email       = ["pyr@cwikla.com"]
  s.homepage    = "http://pyr.cwikla.com"
  s.summary     = "Push notifications utilizing AWS SNS"
  s.description = "Really, it's push notifications utilizing AWS SNS"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 5.0.0"
  # s.add_dependency "jquery-rails"
  s.add_dependency "aws-sdk"
  s.add_dependency "pyr_async"

  #s.add_development_dependency "sqlite3"
end
