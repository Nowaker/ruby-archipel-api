require 'ostruct'
require 'active_support/core_ext/numeric/bytes'


class VmInfo
  class State
    attr_accessor :value, :name
    @@index = {}

    def initialize value, name
      @value, @name = value, name
      @@index[value] = self
    end

    STARTED = new 1, 'started'
    STOPPED = new 5, 'stopped'

    class << self
      private :new
    end

    def method_missing method, *args
      if method[-1] == '?'
        method[0..-2] == name
      else
        super
      end
    end

    def to_s
      "VM state: #{name} (#{value})"
    end

    def self.from_int value
      @@index[value]
    end
  end


  attr_reader :state
  attr_reader :autostart
  attr_reader :memory, :memory_max
  attr_reader :cpu_usage, :cpu_number

  def initialize state, autostart, memory_kib, memory_max_kib, cpu_usage, cpu_number
    @state = State.from_int state.to_i
    @autostart = autostart.to_i == 0 ? false : true

    @memory = memory_kib.to_i * 1024
    @memory_max = memory_max_kib.to_i * 1024

    @cpu_usage = cpu_usage.to_i
    @cpu_number = cpu_number.to_i
  end
end