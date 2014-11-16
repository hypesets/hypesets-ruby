require 'socket'

module Hypesets
  class Client
    attr_reader :connection

    def initialize(hostname = 'localhost', port = 30303)
      @hostname = hostname
      @port = port
    end

    def add(set_name, element)
      connection.puts "ADD #{set_name} #{element}"

      :ok if fetch_response == "DONE\n"
    end

    def estimate(start_name, end_name)
      connection.puts "ESTIMATE #{start_name} #{end_name}"

      fetch_response.split("\n")[0..-2].map do |estimation|
        set_name, cardinality = estimation.split(',')
        Estimation.new set_name, cardinality.to_i
      end
    end

    protected

    def fetch_response
      fetched_response = ''
      fetched_response += connection.gets until fetched_response.end_with? "DONE\n"
      fetched_response
    end

    def connection
      @connection ||= TCPSocket.new @hostname, @port
    end
  end
end

