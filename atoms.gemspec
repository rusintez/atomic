$:.push File.expand_path("../lib", __FILE__)
require "atoms/version"

Gem::Specification.new do |s|
  s.name        = "atoms"
  s.version     = Atoms::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["rusintez"]
  s.email       = ["rusintez@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{atoms = cool.io + rocketamf + grape}
  s.description = %q{an experiment of using cool.io for serving AMF3 to flash clients with API written in grape style}

  s.rubyforge_project = "atoms"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
