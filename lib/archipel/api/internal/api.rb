require 'open3'
require 'xmlsimple'
require 'xmpp4r'
require 'thread'
require 'active_support/core_ext/numeric/time'


class Archipel::Api::Internal::Api
  def initialize config
    config = config.merge Archipel::Api.get_defaults

    @config = config
    config_missing = %i(login password server hypervisor).any? do |property|
      config[property].nil?
    end

    if config_missing
      raise "Login, password, server or hypervisor not provided. " +
          "Use Archipel.defaults or provide constructor parameters to #{self.class.name}."
    end
  end

  def call xml, to = @config[:hypervisor]
    debug xml

    output = in_connection do |client|
      iq = Jabber::Iq.new :set, to
      iq.add REXML::Document.new(xml).elements[1]
      client.send iq
      wait_for_reply 60.seconds, client
    end

    ret = XmlSimple.xml_in output
    raise Exception, ret['error'][0]['text'][0] if ret['error']
    ret
  end

  def in_connection
    Jabber.debug = @config[:xmpp_debug]
    client = Jabber::Client.new Jabber::JID.new @config[:login]
    client.connect @config[:server]
    client.auth @config[:password]
    ret = yield client
    client.close
    ret
  end

  def wait_for_reply timeout, client
    output = nil

    mutex = Mutex.new
    condition = ConditionVariable.new

    client.add_stanza_callback do |stanza|
      next unless %w(result error).include? stanza.attributes['type']
      output = stanza.to_s
      debug output
      mutex.synchronize { condition.signal }
    end

    mutex.synchronize { condition.wait mutex, timeout }
    raise StandardError, "No response given in #{timeout} seconds" unless output
    output
  end

  protected
  def debug text
    return unless debug?
    $stderr.puts
    $stderr.puts text
    $stderr.puts
  end

  private
  def debug?
    @config[:debug]
  end
end
