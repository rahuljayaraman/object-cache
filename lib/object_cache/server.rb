require 'drb'
require_relative './container'

module ObjectCache
  class Server
    def initialize options
      port = options.fetch(:port) { "9999" }
      @uri = "druby://localhost:" + port
      @verbose = options.fetch(:verbose) { false }
    end

    def run!
      container = Container.new(verbose: @verbose)
      DRb.start_service @uri, container
      puts "Caching server running on #{DRb.uri}.."
      DRb.thread.join
    end
  end
end
