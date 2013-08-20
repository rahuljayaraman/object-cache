require 'drb'
require 'zlib'

module ObjectCache
  class Client
    def initialize servers
      DRb.start_service
      @remote_cache_objects = []
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
      @remote_cache_objects << DRbObject.new_with_uri(construct(server))
    end

    def get key
      remote_cache_object_for(:get, key)
    end

    def set key, value
      remote_cache_object_for(:set, key, value)
    end

    def delete key
      remote_cache_object_for(:delete, key)
    end

    def flush
      @remote_cache_objects.each do |cache|
        cache.flush
      end
    end


    private

    def remote_cache_object_for action, key, value=nil
      idx = Zlib.crc32(key) % @remote_cache_objects.count
      @remote_cache_objects[idx].send action, key, value
    end

    def construct uri
      "druby://" + uri
    end
  end
end
