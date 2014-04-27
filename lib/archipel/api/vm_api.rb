require_relative 'internal/api'
require_relative 'internal/vm_xml_messages'
require_relative 'vm/vm_info'


class Archipel::Api::VmApi < Archipel::Api::Internal::Api
  def initialize login: nil, password: nil, server: nil, hypervisor: nil
    @api = Archipel::Api::Internal::VmXmlMessages.new
    super({login: login,
        password: password,
        server: server})
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

  def info jid
    out = method_missing :info, jid
    resp = out['query'][0]['info'][0]
    VmInfo.new resp['state'], resp['autostart'],
        resp['memory'], resp['maxMem'],
        resp['cpuPrct'], resp['nrVirtCpu']
  end

  # Set autostart to new_state; read autostart state when new_state is not given
  def autostart jid, new_state = nil
    if new_state.nil?
      info(jid).autostart
    else
      method_missing :autostart, jid, new_state
    end
  end

  def method_missing symbol, *args
    to = args[0]
    xml = @api.send symbol, *args
    call xml, to
  end
end
