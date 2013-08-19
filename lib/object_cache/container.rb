require 'logger'

module ObjectCache
  class Container
    def initialize params
      @verbose = params.fetch(:verbose) {false}
      @max_size = params.fetch(:max_size)
      @cache = {}
    end

    def set key, value
      log(:set, key, value)
      @cache.store key, value
      if @cache.size > @max_size
        log(:delete, @cache.first[0])
        @cache.delete(@cache.first[0])
      end
    end

    def get key
      log(:get, key)
      @cache.fetch(key) { nil }
    end

    private
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
      end
    end
  end
end

