# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'archipel-api/version'

Gem::Specification.new do |spec|
  spec.name = 'archipel-api'
  spec.version = Archipel::VERSION
  spec.authors = ['Damian Nowak']
  spec.email = ['damian.nowak@pacmanvps.com']
  spec.summary = 'API for Archipel Agent, an XMPP-based orchestrator'
  spec.description = 'Ruby API for Archipel Agent, an XMPP-based orchestrator. See http://archipelproject.org/.'
  spec.homepage = 'https://bitbucket.org/stratushost/ruby-archipel-api'
  spec.license = 'MIT'

  #spec.required_ruby_version = '>= 1.9.3'
  #spec.required_rubygems_version = '>= 1.8.11'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rspec-core', '~> 2.14'
end
