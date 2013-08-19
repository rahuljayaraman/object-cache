### Run the caching server

```
ruby bin/server -p 3000 -v -m 256
```

### Use the cache

```ruby
require_relative './object_cache/client'

cache = ObjectCache::Server.new("localhost:3000").get_cache_object

cache.set 'foo', 'bar'
cache.get 'foo' #=> 'bar'

(1..10).each{|n| cache.set("foo#{n}", "bar") }

cache.size_in_bytes #=> 70
cache.delete("foo1")
cache.size_in_bytes #=> 63

cache.flush
cache.size_in_bytes #=> 0
```
