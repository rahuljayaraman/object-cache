require 'logger'

module ObjectCache
  class Container
    def initialize params
      @verbose = params.fetch(:verbose) {false}
      @max_size = params.fetch(:max_size)
      @cache = {}
    end

    def set key, value
      if size_of_hash_in_bytes(Hash[key, value]) > @max_size
        log(:hash_too_large, key, value)
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
      @cache.fetch(key) { log(:not_found, key); nil }
    end

    def delete key
      log(:delete, key)
      @cache.delete key
    end

    def flush
      log(:flush, nil)
      @cache = {}
    end

    def size_in_bytes
      size_of_hash_in_bytes @cache
    end

    private
    def delete_lru
      if size_in_bytes > @max_size
        log(:delete, oldest_entry)
        @cache.delete(oldest_entry)
        
        #Delete till there's enough room in cache
        delete_lru
      end
    end

    def size_of_hash_in_bytes hash
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
      when :not_found
        log.error "#{key} not found"
      when :hash_too_large
        log.error "Skipping #{key}. Size too large"
      end
    end

  end
end

