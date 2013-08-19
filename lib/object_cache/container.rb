require 'logger'

module ObjectCache
  class CacheOutOfMemory < StandardError; end
  class Container

    def initialize params
      @verbose = params.fetch(:verbose) {false}
      @max_size = params.fetch(:max_size)
      @cache = {}
    end

    def set key, value
      if size_of_hash(Hash[key, value]) > @max_size
        raise CacheOutOfMemoryError
      end

      log(:set, key, value)
      
      #This would be necessary to push a key back to the
      #top if it is updated.
      @cache.delete key

      @cache.store key, value
      delete_lru
    end

    def get key
      log(:get, key)
      @cache.fetch(key) { nil }
    end

    def delete key
      log(:delete, key)
      @cache.delete key
    end

    def flush
      log(:flush, nil)
      @cache = {}
    end

    private
    def delete_lru
      if cache_size > @max_size
        log(:delete, oldest_entry)
        @cache.delete(oldest_entry)
        
        #Delete till there's enough room in cache
        delete_lru
      end
    end

    def cache_size
      size_of_hash @cache
    end

    def size_of_hash hash
      hash.map do |key, value|
        key.size + value.size
      end.inject(0, :+)
    end

    def oldest_entry
      @cache.first[0]
    end

    def log action, key, value=nil
      return unless @verbose
      log = Logger.new(STDOUT)
      case action
      when :set
        log.info "Setting the value of #{key} to #{value}"
      when :get
        log.info "Getting the value of #{key}"
      when :delete
        log.warn "Deleting #{key}"
      when :flush
        log.warn "Flushing all entries"
      end
    end

  end
end

