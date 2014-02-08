dynamic-skiplist
================

Warning: This software is alpha.

This is a ruby skiplist much faster than the ruby skiplist gem here https://github.com/metanest/ruby-skiplist
Times shown are for 1000 operations

this list insert time: 
  0.150000
other skip list insert time: 
  3.540000
this list search time
  0.080000
other list search time
  2.480000
  
Usage:

require 'skiplist'

list = skiplist.new

list[1] = 'dog'
list[2] = 'cat'

list.to_a 
=> ['dog', 'cat']

list.each {|e| puts e}
=> dog
=> cat

list.count
=> 2

list.clear
=> empty list



ToDo: 
Jruby multithreading and locking with mutexes for multi-core support.
