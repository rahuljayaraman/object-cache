### Run the caching server

```
ruby object_cache_server.rb -p 3000 -v
```

### Use the cache

```ruby
require 'object_cache'

cache = ObjectCache.new("localhost:3000")

cache.set 'foo', 'bar'
cache.get 'foo' #=> 'bar'
```
