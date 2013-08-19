### Run the caching server

```
ruby bin/server -p 3000 -v -m 15
```

### Use the cache

```ruby
require 'lib/object_cache/client'

cache = ObjectCache::Server.new("localhost:3000").get_cache_object

cache.set 'foo', 'bar'
cache.get 'foo' #=> 'bar'

(1..10).each{|n| cache.set("foo#{n}", "bar") }

cache.size #=> 10
cache.delete("foo1")
cache.size #=> 9

cache.flush
cache.size #=> 0
```
