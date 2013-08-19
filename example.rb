# !/usr/bin/env ruby -w

require_relative './lib/object_cache/client'

cache = ObjectCache::Client.new("localhost:3000").get_cache_object

(1..20).each do |n|
  cache.set "foo#{n}", "bar#{n}"
end

puts cache.get "foo1"
puts cache.get "foo2"
puts cache.get "foo11"
puts cache.get "foo15"

cache.delete "foo11"
puts cache.get "foo11"

cache.set "foo1", "newFoo"
cache.get "foo1"

cache.flush
