### Start a few caching servers

```
ruby bin/server -p 3000 -vv -m 256
ruby bin/server -p 3001 -vv -m 256
ruby bin/server -p 3002 -vv -m 256
```

### Use the cache

```ruby
require_relative './object_cache/client'

client = ObjectCache::Client.new(["localhost:3000", "localhost:3001"])
client.add_server "localhost:3002"

client.set 'foo', 'bar'
client.get 'foo' #=> 'bar'

client2 = ObjectCache::Client.new("localhost:3000")
client2.set 'foo2', 'bar2'
client2.get 'foo2' #=> 'bar2'

str = "a"
100.times { str += "a" }
client.set "foo1", { longHash: str }
p client.get "foo1" #=> 100 a's

1000.times { str += "a" }
client.set "foo1", { longHash: str } #This will not work due to the 256 byte memory constraint
p client.get "foo1" #=> 100 a's

client.delete("foo1")

client.flush
```
