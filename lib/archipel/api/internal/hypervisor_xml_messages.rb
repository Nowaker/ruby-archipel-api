require_relative 'xml_messages'


class Archipel::Api::Internal::HypervisorXmlMessages
  include Archipel::Api::Internal::XmlMessages

  def register_user jid, password
    render 'register_user', jid: jid, password: password
  end

  def unregister_user jid
    render 'unregister_user', jid: jid
  end

  def create_vm name, user_jid
    parameters = {
        name: name, userid: user_jid,
        orgname: 'StratusHost', orgunit: 'CumulusHost/pacmanvps', locality: 'Gdansk, Poland', categories: 'Archipel'
    }
    render 'create_vm', parameters: parameters
  end

  def list_vm
    render 'list_vm'
  end

  def delete_vm jid
    render 'delete_vm', jid: jid
  end

  def grant_permissions jid, user_jid
    enabled = %w(settags getavatars setavatar presence message info create shutdown destroy reboot suspend resume xmldesc networkinfo define undefine capabilities nodeinfo network_getnames network_bridges appliance_get appliance_attach appliance_detach appliance_package drives_get oom_getadjust scheduler_jobs scheduler_schedule scheduler_unschedule scheduler_actions vnc_display snapshot_take snapshot_delete snapshot_get snapshot_current snapshot_revert)
    disabled = %w(all permission_get permission_getown permission_list permission_set permission_setown subscription_add subscription_remove migrate autostart memory setvcpus free xmppserver_users_list xmppserver_users_number oom_setadjust drives_create drives_delete drives_getiso drives_convert drives_rename vmparking_park)

    render 'grant_permissions', jid: jid, user_jid: user_jid,
        enabled_permissions: enabled, disabled_permissions: disabled
  end

  def list_users page = 0, humans_only = true
    render 'list_users', page: page, humans_only: humans_only
  end

  private
  def generate_mac
    (1..6).map { '%0.2X' % rand(256) }.join ':'
  end
end
