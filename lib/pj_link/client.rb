require 'net/telnet'

module PjLink
  class Client
    attr_accessor :gateway, :password

    def initialize(address, password=nil)
      @gateway = Gateway.new(*address.split(':'))
      @password = password
    end

    def command(cmd)
      gateway.send_message(cmd, @password)
    end

    def power_on
      command 'POWR 1'
    end

    def power_off
      command 'POWR 0'
    end

    def power_status
      command('POWR ?').to_i
    end

    def video_mute_on
      command 'AVMT 11'
    end

    def video_mute_off
      command 'AVMT 10'
    end

    def mute_on
      command 'AVMT 21'
    end

    def mute_off
      command 'AVMT 20'
    end

    def av_mute_on
      command 'AVMT 31'
    end

    def av_mute_off
      command 'AVMT 30'
    end

    def inputs
      command('INST ?').split.sort
    end

    def set_input(input)
      command "INPT #{input}"
    end

    def mute_status
      command('AVMT ?').to_i
    end

    def lamp_hours
      command('LAMP ?').split.map(&:to_i)
    end

    def device_name
      command 'NAME ?'
    end

    def manufacturer
      command 'INF1 ?'
    end

    def product
      command 'INF2 ?'
    end

    def pjlink_class
      command 'CLSS ?'
    end

    def other_info
      command 'INFO ?'
    end

      end
    end
  end
end
