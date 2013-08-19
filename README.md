### Run the caching server

```
ruby bin/server -p 3000 -v
```

### Use the cache

```ruby
require 'lib/object_cache/client'

cache = ObjectCache::Server.new("localhost:3000").get_cache_object

cache.set 'foo', 'bar'
cache.get 'foo' #=> 'bar'
```
