require 'logger'

module ObjectCache
  class Container
    def initialize params
      @verbose = params.fetch(:verbose) {false}
      @cache = {}
    end

    def set key, value
      log(:set, {key: key, value: value})
      @cache.store key, value
    end

    def get key
      log(:get, {key: key})
      @cache.fetch(key) { nil }
    end

    private
    def log action, params
      return unless @verbose
      log = Logger.new(STDOUT)
      case action
      when :set
        log.info "Setting the value of #{params[:key]} to #{params[:value]}"
      when :get
        log.info "Getting the value of #{params[:key]}"
      end
    end
  end
end

