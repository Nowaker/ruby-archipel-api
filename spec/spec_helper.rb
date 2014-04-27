require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler/setup'
require 'archipel/api'
require_relative 'units/api_asserts'
require 'test/unit/assertions'
require 'yaml'
require 'active_support/core_ext/hash'

RSpec.configure do |config|
  include Test::Unit::Assertions

  config_file = File.dirname(__FILE__) + '/api.yml'
  if File.exist? config_file
    config = YAML.load_file(config_file).deep_symbolize_keys
  else
    config = {}
    %w(login password server hypervisor debug xmpp_debug).each do |key|
      config[key.to_sym] = ENV['API_' + key.upcase]
    end
  end

  pp config
  Archipel::Api.defaults **config
end
