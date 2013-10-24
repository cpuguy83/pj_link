require 'net/telnet'

module PjLink
  class Client

    DEFAULT_PORT = 4352
    attr_accessor :address, :password
    def initialize(address, password=nil)
      @address = address
      @password = password
      parse_address
    end
  private
    def parse_address
      if address =~ /:\n+/
        @address, @port = *address.split(':')
      else
        @port = DEFAULT_PORT
      end
    end
  end
end
