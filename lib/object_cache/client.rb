require 'drb'
require 'zlib'
require 'digest/sha1'

module ObjectCache
  class Client
    def initialize servers
      DRb.start_service
      @continuum_list = []
      if servers.instance_of? String
        add_server servers
      elsif servers.instance_of? Array
        servers.each do |server|
          add_server server
        end
      else
        raise ArgumentError
      end
    end

    def add_server server
      @continuum_list << CreateContinuum.new(server)
      @continuum_list.sort {|a,b| a.value <=> b.value}
    end

    def get key
      server = find_server_for(key)
      server.get(key)
    end

    def set key, value
      server = find_server_for(key)
      server.set(key, value)
    end

    def delete key
      server = find_server_for(key)
      server.delete(key)
    end

    def flush
      @continuum_list.each do |c|
        c.server.flush
      end
    end

    private
    def find_server_for key
      find_closest_match(hash_for(key))
    end

    def find_closest_match key
      @continuum_list.min_by do |x| 
        (x.value - key).abs
      end.server
    end

    def hash_for(key)
      Zlib.crc32(key)
    end
  end

  class CreateContinuum
    attr_reader :server, :value

    def initialize server
      @server = DRbObject.new_with_uri(construct(server))
      @value = checksum_for(server)
    end

    private
    def checksum_for server
      hash = Digest::SHA1.hexdigest server
      Integer("0x#{hash[0..7]}")
    end

    def construct uri
      "druby://" + uri
    end
  end
end
