# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adhearsion_amqp/version"

Gem::Specification.new do |s|
  s.name        = "adhearsion_amqp"
  s.version     = AdhearsionAmqp::VERSION
  s.authors     = ["Brad Smith"]
  s.email       = ["bradleydsmith@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{ Publishes messages to a AMQP host}
  s.description = %q{ Publishes events or billing information to an AMQP host}

  s.rubyforge_project = "adhearsion_amqp"

  # Use the following if using Git
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.files         = Dir.glob("{lib}/**/*") + %w( README.md Rakefile Gemfile)
  s.test_files    = Dir.glob("{spec}/**/*")
  s.require_paths = ["lib"]

  s.add_runtime_dependency %q<adhearsion>, ["~> 2.2"]
  s.add_runtime_dependency %q<activesupport>, [">= 3.0.10"]
  s.add_runtime_dependency 'amqp'

  s.add_development_dependency %q<bundler>, ["~> 1.0"]
  s.add_development_dependency %q<rspec>, ["~> 2.5"]
  s.add_development_dependency %q<rake>, [">= 0"]
  s.add_development_dependency %q<mocha>, [">= 0"]
  s.add_development_dependency %q<guard-rspec>
  s.add_development_dependency %q<evented-spec>
 end
