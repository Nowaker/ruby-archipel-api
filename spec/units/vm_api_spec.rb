require_relative '../spec_helper'
require 'archipel/api/vm_api'


describe Archipel::Api::VmApi do
  include ApiAsserts

  JID = '8e8d080c-cd9a-11e3-947c-0cc47a000e08@xmpp.pacmanvps.com/asgard'

  before do
    @api = Archipel::Api::VmApi.new
  end


  describe 'main features' do
    it 'creates a storage' do
      out = @api.create_disk JID, 'disk', 5, 'qcow2'
      assert_success out
    end

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

    it 'enables autostart' do
      out = @api.autostart JID, true
      assert_success out

      autostart = @api.autostart JID
      autostart.should be_true
    end

    it 'gets VM info' do
      info = @api.info JID

      info.state.stopped?.should be_true
      info.state.started?.should be_false
      info.autostart.should be_true
      info.memory.should be 128.megabytes
      info.memory_max.should be 128.megabytes
      info.cpu_number.should be 1
      info.cpu_usage.should be_between 0, 100
    end

    it 'starts VM' do
      @api.start JID
    end

    it 'stop VM gracefully' do
      @api.stop JID
      info = @api.info JID
      assert info.state.started? # because Arch Linux ISO doesn't respond to ACPI calls
    end

    it 'force stops VM' do
      @api.force_stop JID

      info = @api.info JID
      assert info.state.stopped?
    end

    it 'disables autostart' do
      out = @api.autostart JID, false
      assert_success out

      autostart = @api.autostart JID
      autostart.should be_false
    end

    it 'removes the storage' do
      out = @api.remove_disk JID, 'disk', 'qcow2'
      assert_success out

      disks = @api.list_disks JID
      matching_disk = disks.find_all { |disk| disk['name'] == 'test-disk' && disk['format'] == 'qcow2' }
      matching_disk.should be_empty
    end
  end

  describe 'misc features' do
    it 'asks the user for subscription' do
      out = @api.subscribe JID, 'test@xmpp.pacmanvps.com'
      assert_success out
    end

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
