require './skiplist.rb'
require 'benchmark'
require 'skiplist'
list = DSkipList.new
puts "this list insert time: "
puts Benchmark.measure {1.upto(10000) {|i| list[i]=i }}

otherList = SkipList.new 100
puts "other skip list insert time: "
puts Benchmark.measure {1.upto(10000) {|i| otherList[i] = i}}

puts "this list search time"
puts Benchmark.measure {1.upto(10000) {|s| list[s]}}

puts "other list search time"
puts Benchmark.measure {1.upto(10000) {|s| otherList[s]}}
puts "list level " + list.level.to_s
list[100000000] = "value"
puts "large number reads" + list[100000000].to_s

def test(list)
  complete = list.to_a
  1.upto(list.level) do |l|
    #if anything in the higher layer wasn't in layer 0
    difference = list.to_a(l) - complete
    puts "test failed level #{l} ,inconsistent node(s) #{difference}" if (difference.count != 0)
  end
  puts "test complete"
end
test(list) 
list.clear

puts "attempting to use string as key"
list["hello"] = "world"
puts "the output of key hello is: " + list["hello"]
