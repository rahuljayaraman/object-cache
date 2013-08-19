# !/usr/bin/env ruby -w

require_relative './lib/object_cache/client'

cache = ObjectCache::Client.new("localhost:3000").get_cache_object

cache.set "bar", "qux"

puts cache.get "bar"
