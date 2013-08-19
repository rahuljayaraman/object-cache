# !/usr/bin/env ruby -w

require_relative './object_cache/client'

client = ObjectCache::Client.new(["localhost:3000", "localhost:3001"])
client.add_server "localhost:3002"

(1..20).each do |n|
  client.set "foo#{n}", "bar#{n}"
end

(1..20).each do |n|
  puts client.get "foo#{n}"
end

client.delete "foo11"
puts client.get "foo11"

client.set "foo1", "newFoo"
client.get "foo1"
client.flush
