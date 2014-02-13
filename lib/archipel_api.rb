module Archipel
  module Internal
  end

  def self.defaults login: nil, password: nil, server: nil, hypervisor: nil, **kwargs
    @config = {login: login, password: password, server: server, hypervisor: hypervisor}
  end

  def self.get_defaults
    @config || {}
  end
end
