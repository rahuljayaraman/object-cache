# !/usr/bin/env ruby -w

require_relative './lib/object_cache/client'

client = ObjectCache::Client.new(["localhost:3000", "localhost:3001"])

(1..20).each do |n|
  client.set "foo#{n}", "bar#{n}"
end

puts "Starting with 2 servers-------------------------"
(1..20).each do |n|
  puts client.get "foo#{n}"
end

puts "Deleting a key----------------------------"
client.delete "foo11"
puts client.get "foo11"

puts "Testing memory validations--------------------------"
str = "a"
1000.times { str += "a" }
client.set "foo1", { longHash: str }
p client.get "foo1"
puts "Output should be bar1 and not a 1000 a's"

puts "Removing a server-------------------------Losing 50% keys"
client.remove_server "localhost:3000"
(1..10).each do |n|
  puts client.get "foo#{n}"
end

puts "Adding a server--------------------------------Losing 10% keys"
client.add_server "localhost:3002"
(1..10).each do |n|
  puts client.get "foo#{n}"
end

puts "Flushing all servers---------------------------------------"
client.flush
