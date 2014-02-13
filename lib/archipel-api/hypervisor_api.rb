require_relative 'internal/api'
require_relative 'internal/hypervisor_xml_messages'

class Archipel::HypervisorApi < Archipel::Internal::Api
  def initialize login: nil, password: nil, server: nil, hypervisor: nil
    @api = Archipel::Internal::HypervisorXmlMessages.new
    super({login: login,
        password: password,
        server: server,
        hypervisor: hypervisor})
  end

  def create_vm name, user_jid
    resp = method_missing :create_vm, name, user_jid
    vm_jid = resp['query'][0]['virtualmachine'][0]['jid']
    hypervisor_name = resp['from'].split('@')[0]
    vm_jid + '/' + hypervisor_name
  end

  def delete_vm jid_or_name
    if jid_or_name.include? '@'
      jid = jid_or_name
    else
      name = jid_or_name
      jid = get_vm_jid_by_name name
    end
    method_missing :delete_vm, jid
  end

  def list_vm
    resp = method_missing :list_vm
    vms_resp = resp['query'][0]['item']
    vms = {}
    vms_resp.each do |vm|
      vms[vm['name']] = vm['content']
    end
    vms
  end

  def get_vm_jid_by_name name
    jid = list_vm[name]
    raise "VM #{name} not found" if jid.nil?
    jid
  end

  def list_users human_only = true
    all_users = []
    page = 0
    loop do
      resp = method_missing :list_users, page, human_only
      users = resp['query'][0]['user']
      break if users.blank?

      all_users += users
      page += 1
    end

    all_users.map { |e| e['jid'].downcase }
  end

  def user_exist? jid
    list_users.include? jid.downcase
  end

  def method_missing symbol, *args
    xml = @api.send symbol, *args
    call xml
  end
end
