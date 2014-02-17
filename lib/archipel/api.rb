module Archipel
  module Api
    module Internal
    end

    def self.defaults login: nil, password: nil, server: nil, hypervisor: nil, **kwargs
      @config = {login: login, password: password, server: server, hypervisor: hypervisor}
      @config.merge! kwargs
    end

    def self.get_defaults
      @config || {}
    end
  end
end
