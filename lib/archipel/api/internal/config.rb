class Archipel::Api::Internal::Config
  attr_reader :config


  def initialize name
    config_file = File.join Rails.root, 'config', "#{name}.yml"
    @config = YAML.load_file(config_file)[Rails.env].deep_symbolize_keys
  end

  def [] entry
    @config[entry]
  end
end