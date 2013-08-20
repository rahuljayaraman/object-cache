require 'logger'

module ObjectCache
  class Container
    def initialize params
      @verbosity = params.fetch(:verbosity)
      @max_size = params.fetch(:max_size)
      @cache = {}
    end

    def set key, value
      if size_of_hash_in_bytes(Hash[key, value]) > @max_size
        log_error(:object_too_large, key)
        return
      end

      log(:set, key, value)
      
      #This would be necessary to push a key back to the
      #top if it is updated.
      @cache.delete key

      @cache.store key, value
      delete_lru
    end

    def get key, value=nil
      value = @cache.fetch(key) { log_error(:not_found, key); nil }
      log(:get, key, value)
      value
    end

    def delete key, value=nil
      log_warning(:delete, key)
      @cache.delete key
    end

    def flush
      log_warning(:flush, nil)
      @cache = {}
    end

    def size_in_bytes
      size_of_hash_in_bytes @cache
    end

    private
    def delete_lru
      if size_in_bytes > @max_size
        log_warning(:delete, oldest_entry)
        @cache.delete(oldest_entry)
        
        #Delete till there's enough room in cache
        delete_lru
      end
    end

    def size_of_hash_in_bytes hash
      hash.map do |key, value|
        key.size + Marshal.dump(value).size
      end.inject(0, :+)
    end

    def oldest_entry
      @cache.first[0]
    end

    def log action, key, value=nil
      return unless high_verbosity
      log = Logger.new(STDOUT)
      case action
      when :set
        log.info "Setting the value of #{key} to #{value}"
      when :get
        log.info "Getting the value of #{key}: #{value}"
      end
    end

    def log_error action, key
      log = Logger.new(STDOUT)
      case action
      when :not_found
        log.error "#{key} not found"
      when :object_too_large
        log.error "Skipping #{key}. Size larger than #{@max_size} bytes"
      end
    end

    def log_warning action, key
      return unless low_verbosity
      log = Logger.new(STDOUT)
      case action
      when :delete
        log.warn "Deleting #{key}"
      when :flush
        log.warn "Flushing all entries"
      end
    end

    def high_verbosity
      @verbosity == :high
    end

    def low_verbosity
      @verbosity == :high || @verbosity == :low
    end

  end
end

