# DSkipList

#What is a skiplist?
A skiplist is similar to a linked list, where every node holds the next node.  In a skiplist, some of the nodes are connected to more distant nodes.  This allows you to jump quickly through ordered nodes, acheiving O(log (n)) or better performance for any operation, including search and selecting ordered ranges.

Warning: This software is alpha. If you find a bug, please file the issue on github.  Master contains incremental changes and may be broken, but the [gem](http://rubygems.org/gems/dskiplist) is usably stable.

This is a ruby skiplist much faster than the ruby skiplist gem here https://github.com/metanest/ruby-skiplist
Benchmarks below



## Installation

Add this line to your application's Gemfile:

    gem 'dskiplist'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dskiplist

## Usage
``` ruby
require 'dskiplist'

list = DSkipList.new

#anything comparable is a valid key, just keep the type consistent. Any value is valid
list[1] = 'dog'
list[2] = 'cat'

#or

list.insert_hash Hash[3 => 'fish']

list[1]
=> 'dog'

list.to_a 
=> ['dog', 'cat', 'fish']

list.to_h
=> {1=>"dog", 2=>"cat", 3=>"fish"}

list.each {|e| puts e.reverse}
=> god
=> tac
=> shif


list.count
=> 3

list.clear
=> empty list



```
## Benchmarks
Other list: https://github.com/metanest/ruby-skiplist

```ruby
this list insert 10000 elements time: 
  0.150000
other skip list insert 10000 elements time: 
  3.540000
this list search 10000 elements time
  0.080000
other list search 10000 elements time
  2.480000
```
But slower than Ruby's hash
```ruby 
                                     user     system      total        real
List insert million elements:   23.680000   0.150000  23.830000 ( 25.223663)
Hash insert million elements:    2.740000   0.060000   2.800000 (  2.949170)
List search 10000 elements       0.140000   0.000000   0.140000 (  0.169945)
Hash search 10000 elements       0.050000   0.000000   0.050000 (  0.104777)

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
>> through = 3
#0 is the base layer of the list.  It contains all elements. default 0
>> layer = 0
#limit return size if desired
>> limit = nil

>> list.to_a(from, through, limit, layer)
=> ["goose", "quail"]
#note that "duck" was omitted.  The range does not include the first element.  
#You can also use nonexistent node keys like 1.5

#with a start point, no endpoint, and a limit:
>> list.to_a(2, nil, 2)
=> ["quail", "pidgin"]
>> list.to_a(nil, 3, nil)
=> ["duck", "goose", "quail"]

#or count the elements between two values (+1 because endpoint is counted) from 1 to 3
>> list.count(from, through)
=> 2

```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/dskiplist/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request




ToDo: 
- Jruby multithreading and locking with mutexes for multi-core support.
- Lazy operations.  For now you can just do them yourself by using find_node to get your start point and calling forward[0] to get the following nodes in O(1) time
- considering making count O(1) instead of O(log n) by just keeping track of the size 
