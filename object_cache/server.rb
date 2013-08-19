require 'drb'
require_relative './lib/container'

module ObjectCache
  class Server
    def initialize options
      port = options.fetch(:port) { "9999" }
      @uri = "druby://localhost:" + port

      @max_size = options.fetch(:size) { 10 }

      @verbose = options.fetch(:verbose) { false }
    end

    def run!
      container = Container.new(verbose: @verbose, max_size: @max_size.to_i)
      DRb.start_service @uri, container
      puts "Caching server running on #{DRb.uri}.."
      DRb.thread.join
    end
  end
end
