require_relative '../spec_helper'
require 'archipel/api/hypervisor_api'


describe Archipel::Api::HypervisorApi do
  include ApiAsserts

  VM_NAME = 'pacmanvps-unit-test'
  VM_OWNER = 'pacmanvps-robot@xmpp.pacmanvps.com'

  before do
    @api = Archipel::Api::HypervisorApi.new
  end

  describe 'user management' do
    it 'registers a user' do
      out = @api.register_user 'example@xmpp.pacmanvps.com', 'V0Rn5o7XnWHiuW7q7vpWJs8Z0fn5KejyW'
      assert_success out
    end

    # https://github.com/ArchipelProject/Archipel/issues/1058
    # it 'does not register a user that already exists' do
    #   expect { @api.register_user 'example@xmpp.pacmanvps.com', 'x' }.to raise_error
    # end

    it 'lists all human users' do
      out = @api.list_users
      expect(out).to include 'example@xmpp.pacmanvps.com'
    end

    it 'lists all users' do
      out = @api.list_users false
      expect(out).to include 'example@xmpp.pacmanvps.com'
      expect(out).to include 'utgard@xmpp.pacmanvps.com'
    end

    it 'finds user by name' do
      expect(@api.user_exist? 'example@xmpp.pacmanvps.com').to be_true
      expect(@api.user_exist? 'doesnotexist@xmpp.pacmanvps.com').to be_false
    end

    it 'user find is case insensitive' do
      expect(@api.user_exist? 'EXAMPLE@xmpp.pacmanvps.com').to be_true
    end

    it 'removes a user' do
      out = @api.unregister_user 'example@xmpp.pacmanvps.com'
      assert_success out
    end
  end

  describe 'vm management' do
    def delete_vm vm_jid
      out = @api.delete_vm vm_jid
      assert_success out
    end

    it 'creates and deletes virtual machine by JID' do
      vm_jid = @api.create_vm VM_NAME, VM_OWNER
      vm_jid.should end_with '@xmpp.pacmanvps.com/asgard'
      delete_vm vm_jid
    end

    it 'creates and deletes virtual machine by name' do
      vm_jid = @api.create_vm VM_NAME, VM_OWNER
      vm_jid.should end_with '@xmpp.pacmanvps.com/asgard'
      delete_vm VM_NAME
    end

    it 'refuses to create a VM with duplicate name' do
      vm_jid = @api.create_vm VM_NAME, VM_OWNER
      expect { @api.create_vm VM_NAME, VM_OWNER }.to raise_error
      delete_vm vm_jid
    end

    # https://github.com/ArchipelProject/Archipel/issues/1016
    #it 'creates virtual machine with arbitrary JID localpart' do
    #  vm_jid = @api.create_vm VM_NAME, VM_OWNER, VM_NAME
    #  assert_equal "#{VM_NAME}@xmpp.pacmanvps.com/utgard", vm_jid
    #  #delete_vm vm_jid
    #end

    #it 'refuses to create a VM with duplicate JID localpart' do
    #  vm_jid = @api.create_vm VM_NAME, VM_OWNER, VM_NAME
    #  expect { @api.create_vm VM_NAME + "2", VM_OWNER, VM_NAME }.to raise_error
    #  delete_vm vm_jid
    #end
  end
end
