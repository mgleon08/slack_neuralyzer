# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slack_neuralyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "slack_neuralyzer"
  spec.version       = SlackNeuralyzer::VERSION
  spec.authors       = ["Leon Ji"]
  spec.email         = ["mgleon08@gmail.com"]

  spec.summary       = %q{The easiest way to clean up messages and files on Slack.}
  spec.description   = %q{This is a ruby gem for bulk delete messages and files on Slack channels.}
  spec.homepage      = "https://github.com/mgleon08/slack_neuralyzer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.require_paths = ["lib"]
  spec.executables   = ["slack_neuralyzer"]

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls", "~> 0.8.1"
  spec.add_runtime_dependency "slack-api", "~> 1.2"
  spec.add_runtime_dependency "colorize", "~> 0.8"
end
