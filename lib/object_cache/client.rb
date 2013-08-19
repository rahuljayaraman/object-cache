require 'drb'

module ObjectCache
  class Client
    attr_accessor :cache

    def initialize uri
      DRb.start_service
      @cache = DRbObject.new_with_uri(construct(uri))
    end

    private
    def construct uri
      "druby://" + uri
    end
  end
end
