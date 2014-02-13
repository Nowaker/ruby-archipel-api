require_relative 'internal/api'
require_relative 'internal/vm_xml_messages'


class Archipel::VmApi < Archipel::Internal::Api
  def initialize login: nil, password: nil, server: nil, hypervisor: nil
    @api = Archipel::Internal::VmXmlMessages.new
    super({login: login,
        password: password,
        server: server,
        hypervisor: hypervisor})
  end

  def remove_disk jid, name, format
    disks = list_disks jid
    found_disk = disks.find do |disk|
      disk['name'] == name && disk['format'] == format
    end
    method_missing :remove_disk, jid, found_disk['path']
  end

  def list_disks jid
    out = method_missing :list_disks, jid
    out['query'][0]['disk'] || []
  end

  def xml jid
    out = method_missing :xml, jid
    out['query'][0]['domain'][0]
  end

  def method_missing symbol, *args
    to = args[0]
    xml = @api.send symbol, *args
    call xml, to
  end
end
