require_relative '../spec_helper'
require 'archipel/api/vm_api'


describe Archipel::Api::VmApi do
  include ApiAsserts

  JID = 'efd09d90-6ac6-11e3-8a34-d8d385c218d2@xmpp.pacmanvps.com/utgard'

  before do
    @api = Archipel::Api::VmApi.new
  end

  describe 'manage storage' do
    it 'creates a storage' do
      out = @api.create_disk JID, 'test-disk', 5, 'qcow2'
      assert_success out
    end

    it 'removes the storage' do
      out = @api.remove_disk JID, 'test-disk', 'qcow2'
      assert_success out

      disks = @api.list_disks JID
      matching_disk = disks.find_all { |disk| disk['name'] == 'test-disk' && disk['format'] == 'qcow2' }
      matching_disk.should be_empty
    end
  end

  describe 'main features' do
    it 'defines a configuration' do
      out = @api.define_vm JID,
          name: 'pacmanvps-unit-test-define',
          memory: 128,
          cpu: 1,
          iso: 'archlinux-latest',
          ip: '8.8.8.8'
      assert_success out
    end

    it 'gets the XML descriptor' do
      out = @api.xml JID
      assert_equal 'pacmanvps-unit-test-define', out['name'][0]
    end

    it 'asks the user for subscription' do
      out = @api.subscribe JID, 'test@xmpp.pacmanvps.com'
      assert_success out
    end
  end

  describe 'permissions management' do
    it 'grants permissions' do
      out = @api.grant_permissions JID, 'test@xmpp.pacmanvps.com'
      assert_success out
    end

    it 'revokes permissions' do
      out = @api.revoke_permissions JID, 'test@xmpp.pacmanvps.com'
      assert_success out
    end
  end
end
