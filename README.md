### Run the caching server

```
ruby bin/server -p 3000 -v
```

### Use the cache

```ruby
require 'lib/object_cache/client'

cache = ObjectCache.new("localhost:3000").cache

cache.set 'foo', 'bar'
cache.get 'foo' #=> 'bar'
```
