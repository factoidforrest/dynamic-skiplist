dynamic-skiplist
================

Warning: This software is alpha.

This is a ruby skiplist much faster than the ruby skiplist gem here https://github.com/metanest/ruby-skiplist
Times shown are for 1000 operations
```ruby
this list insert time: 
  0.150000
other skip list insert time: 
  3.540000
this list search time
  0.080000
other list search time
  2.480000
```
But slower than Ruby's hash
```ruby 
                                     user     system      total        real
List insert million elements:   23.680000   0.150000  23.830000 ( 25.223663)
Hash insert million elements:    2.740000   0.060000   2.800000 (  2.949170)
List search 10000                0.140000   0.000000   0.140000 (  0.169945)
Hash search 10000                0.050000   0.000000   0.050000 (  0.104777)

```
Ok, so why use this instead of hash? Order
```ruby
>> list[1] = "duck"
>> list [2] = "goose"
>> list[3] = "quail"
>> list[4] = "pidgin"

>> list.smallest
=> "duck"
>> list.largest
=> "pidgin"

#get your elements in order
>> list.to_a
=> ["duck", "goose", "quail", "pidgin"]

#or in a range
>> from = 1
>> to = 3
#0 is the base layer of the list.  It contains all elements. default 0
>> layer = 0
#limit return size if desired
>> limit = nil

>> list.to_a(from, to, limit, layer)
=> ["duck", "goose", "quail"]
>> list.to_a(2, nil, 2)
=> ["goose", "quail"]
>> list.to_a(nil, 3, nil)
=> ["duck", "goose", "quail"]




```
Usage:
``` ruby
require 'skiplist'

list = skiplist.new

list[1] = 'dog'
list[2] = 'cat'

list.to_a 
=> ['dog', 'cat']

list.each {|e| puts e.reverse}
=> god
=> tac

list.count
=> 2

list.clear
=> empty list

```

ToDo: 
Jruby multithreading and locking with mutexes for multi-core support.
Lazy operations
hash to skiplist, skiplist to hash
