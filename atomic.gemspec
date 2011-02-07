# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'cool.io'
require 'stringio'
require 'rocketamf'
require "atomic/version"

Gem::Specification.new do |s|
  s.name        = "atomic"
  s.version     = Atomic::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["rusintez"]
  s.email       = ["rusintez@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{RocketAMF + Grape + Cool.io}
  s.description = %q{A socket server (cool.io), with simple dsl to add api methods (grape), with rocketamf wrapper for flash clients.}
  
  s.rubyforge_project = "atomic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
