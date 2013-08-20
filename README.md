### Start a few caching servers

```
ruby bin/server -p 3000 -vv -m 256
ruby bin/server -p 3001 -vv -m 256
ruby bin/server -p 3002 -vv -m 256
```

### Use the cache

```ruby
require_relative './object_cache/client'

cache = ObjectCache::Client.new(["localhost:3000", "localhost:3001"])
cache.add_server "localhost:3002"

cache.set 'foo', 'bar'
cache.get 'foo' #=> 'bar'

(1..10).each{|n| cache.set("foo#{n}", "bar") }

cache.delete("foo1")

cache.flush
```
