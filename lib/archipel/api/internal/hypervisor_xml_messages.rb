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

  def list_users page = 0, humans_only = true
    render 'list_users', page: page, humans_only: humans_only
  end

  private
  def generate_mac
    (1..6).map { '%0.2X' % rand(256) }.join ':'
  end
end
