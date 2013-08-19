# !/usr/bin/env ruby -w

require_relative './lib/object_cache/client'

cache = ObjectCache::Client.new("localhost:3000").get_cache_object

(1..20).each do |n|
  cache.set "foo#{n}", "bar#{n}"
end

puts cache.get "foo11"
puts cache.get "foo15"

puts cache.size_in_bytes
cache.delete "foo11"
puts cache.size_in_bytes
puts cache.get "foo11"

cache.set "foo1", "newFoo"
cache.get "foo1"

puts cache.size_in_bytes
cache.flush
puts cache.size_in_bytes
