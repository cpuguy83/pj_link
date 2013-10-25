require 'net/telnet'
require 'digest/md5'

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

    class Gateway
      class ::PjLink::Client::PasswordRequiredError < StandardError; end
      DEFAULT_PORT = 4352

      attr_reader :connection, :connection_key, :port, :address

      def initialize(address, port=DEFAULT_PORT)
        @address, @port = address, port.to_i
      end

      def send_message(message, password)
        retry_count = 0
        begin
          connect(password)
          @connection.write("#{@password_hash}%1#{message}\r")
          response = @connection.waitfor("Prompt" => /%1/).
            gsub(/^.*=/, "")

          response
        rescue Errno::EPIPE
          if retry_count < 4
            disconnect
            retry_count += 1
            retry
          else
            raise
          end
        rescue Net::ReadTimeout
          raise PasswordRequiredError,
            "You must provide a password to access this device"
        ensure
          disconnect
        end
      end
    private
      def connect(password)
        retry_count = 0
        begin
          @connection = Net::Telnet.new(
            'Host' => @address,
            'Port' => @port,
            'Telnetmode' => false,
            'Promp' => /%1/)
          _, auth_required, key = *@connection.sock.recvmsg[0].split
        rescue Errno::ECONNRESET
          if retry_count < 4
            retry_count += 1
            sleep 1
            retry
          else
            raise
          end
        end

        @password_hash = Digest::MD5.hexdigest("#{key}#{password}") if auth_required
        self
      end

      def disconnect
        begin
          @connection.close if @connection
        rescue IOError; nil
        ensure
          @connection = nil
        end
      end

    end

  end
end

