# !/usr/bin/env ruby -w

require_relative './lib/object_cache/client'

cache = ObjectCache::Client.new("localhost:9999").cache

cache.set "bar", "qux"

puts cache.get "bar"
