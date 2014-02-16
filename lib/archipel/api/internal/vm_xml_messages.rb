require_relative 'xml_messages'


class Archipel::Api::Internal::VmXmlMessages
  include Archipel::Api::Internal::XmlMessages

  def create_disk jid, name, size_gb, format = 'qcow2'
    render 'create_disk', jid: jid, uuid: uuid_from_jid(jid),
        name: name, size: size_gb, format: format
  end

  def define_vm jid, params = {}
    params = params.dup

    uuid = uuid_from_jid jid
    params.merge! jid: jid, uuid: uuid

    params.merge! mac: generate_mac unless params.key? :mac

    if params.key? :ip
      params[:ips] = [params[:ip]]
    end

    params[:vnc_password] = generate_password 50 unless params.key? :vnc_password
    params[:vnc_port] = -1 unless params.key? :vnc_port

    render 'define_vm', params
  end

  def list_disks jid
    render 'list_disks', uuid: uuid_from_jid(jid)
  end

  def remove_disk jid, file
    render 'remove_disk', uuid: uuid_from_jid(jid), file: file
  end

  def grant_permissions jid, user_jid
    enabled = %w(settags getavatars setavatar presence message info create shutdown destroy reboot suspend resume xmldesc networkinfo define undefine capabilities nodeinfo network_getnames network_bridges appliance_get appliance_attach appliance_detach appliance_package drives_get oom_getadjust scheduler_jobs scheduler_schedule scheduler_unschedule scheduler_actions vnc_display snapshot_take snapshot_delete snapshot_get snapshot_current snapshot_revert)
    disabled = %w(all permission_get permission_getown permission_list permission_set permission_setown subscription_add subscription_remove migrate autostart memory setvcpus free xmppserver_users_list xmppserver_users_number oom_setadjust drives_create drives_delete drives_getiso drives_convert drives_rename vmparking_park)

    render 'grant_permissions', jid: jid, uuid: uuid_from_jid(jid), user_jid: user_jid,
        enabled_permissions: enabled, disabled_permissions: disabled
  end

  def revoke_permissions jid, user_jid
    disabled = %w(settags getavatars setavatar presence message info create shutdown destroy reboot suspend resume xmldesc networkinfo define undefine capabilities nodeinfo network_getnames network_bridges appliance_get appliance_attach appliance_detach appliance_package drives_get oom_getadjust scheduler_jobs scheduler_schedule scheduler_unschedule scheduler_actions vnc_display snapshot_take snapshot_delete snapshot_get snapshot_current snapshot_revert all permission_get permission_getown permission_list permission_set permission_setown subscription_add subscription_remove migrate autostart memory setvcpus free xmppserver_users_list xmppserver_users_number oom_setadjust drives_create drives_delete drives_getiso drives_convert drives_rename vmparking_park)

    render 'grant_permissions', jid: jid, uuid: uuid_from_jid(jid), user_jid: user_jid,
        enabled_permissions: [], disabled_permissions: disabled
  end

  def start jid
    render 'start', jid: jid, uuid: uuid_from_jid(jid)
  end

  def xml jid
    render 'xml', jid: jid, uuid: uuid_from_jid(jid)
  end

  def subscribe jid, user_jid
    render 'subscribe', jid: jid, uuid: uuid_from_jid(jid), user_jid: user_jid
  end

  private
  def generate_mac
    (1..6).map { '%0.2X' % rand(256) }.join ':'
  end

  def uuid_from_jid jid
    jid.split('@').first
  end
end
