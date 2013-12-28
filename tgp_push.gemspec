$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tgp/push/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tgp_push"
  s.version     = Tgp::Push::VERSION
  s.authors     = ["The Giant Pixel Corporation"]
  s.email       = ["gems@thegiantpixel.com"]
  s.homepage    = "http://www.thegiantpixel.com"
  s.summary     = "Push notifications utilizing AWS SNS"
  s.description = "Really, it's push notifications utilizing AWS SNS"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"
  s.add_dependency "aws-sdk"
  s.add_dependency "tgp_async"
  s.add_dependency "rapns"

  #s.add_development_dependency "sqlite3"
end
