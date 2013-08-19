require 'drb'

module ObjectCache
  class Client
    def initialize uri
      DRb.start_service
      @cache = DRbObject.new_with_uri(construct(uri))
    end

    def get_cache_object
      @cache
    end

    private
    def construct uri
      "druby://" + uri
    end
  end
end
