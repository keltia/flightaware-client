# @abstract Poor Man's version of a FlightAware client
#
# @author Ollivier Robert <ollivier.robert@eurocontrol.int>
# @copyright 2015 by Ollivier Robert for ECTL

# External modules
require 'celluloid/io'

# Main module
module FlightAware
  class Client
    include Celluloid::IO

    attr_reader :bytes
    attr_reader :pkts

    def initialize(config, out = nil)
      @bytes = 0
      @pkts = 0
      @out = out || Proc.new{|buf| $stderr.puts(buf) }

      puts("Connecting to #{config.site}:#{config.port} using TLS.")
      raw_socket = TCPSocket.new(config.site, config.port)
      puts("  Initiating TLS negociation")
      @ssl = SSLSocket.new(raw_socket)
      @ssl.connect
      puts("  Authenticating to FlightAware")
      @ssl.write("live version 4.0 username #{config.user} password #{config.password} events \"position\"\n")
      puts("Init done.")
      async.run
    end

    # Read buffer, one line at a time
    #@param [Proc] out callback to do something with the packet
    def run
      buf = @ssl.read
      @out.call(buf)
      @bytes += buf.size
      @pkts += 1
    end

    def wait
      sleep(1)
    end
  end
end
