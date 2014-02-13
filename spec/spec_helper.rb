require 'rubygems'
require 'bundler/setup'
require 'archipel_api'
require_relative 'units/api_asserts'
require 'test/unit/assertions'
require 'yaml'
require 'active_support/core_ext/hash'

RSpec.configure do |config|
  include Test::Unit::Assertions

  config = YAML.load_file File.dirname(__FILE__) + '/api.yml'
  config = config.deep_symbolize_keys
  Archipel.defaults **config
end
