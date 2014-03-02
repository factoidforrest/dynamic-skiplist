require './lib/dskiplist.rb'
require 'benchmark'
require 'skiplist'
list = DSkipList.new
otherList = SkipList.new 100
hash = {}
Benchmark.bm(30) do |b| 
  b.report('Insert time: ') {1.upto(10000) {|i| list[i] = i}}
  #b.report('Other list insert: ') {1.upto(10000) {|i| otherList[i] = i}}
  b.report('Search time: ') {1.upto(10000) {|i| list[i]}}
  #b.report('Other list search: ') {1.upto(10000) {|i| otherList[i]}}
  #b.report('List insert million elements: ') {10000.upto(1010000) {|i| list[i] = i}}
  #b.report('Hash insert million elements: ') {1.upto(1000000) {|i| hash[i] = i}}
  b.report('List search 10000') {1.upto(10000) {|i| list[i]}}
  #b.report('Hash search 10000') {900000.upto(1000000) {|i| hash[i]}}
  #b.report('List +10000: ') {1040000.upto(1050000) {|i| list[i] = i}}
  #b.report('Search time: ') {1000000.upto(1010000) {|i| list[i]}}
  b.report('to_a: ') {list.to_a}
  b.report('to_h: ') {list.to_h}
end
hash = Hash['a'=> 1, 'b'=>2, 'c'=>3] 
puts "the hash size is " + hash.count.to_s
puts list.insert_hash hash
puts list.to_s
puts list
puts "list size: " + list.count.to_s
puts list.to_a.to_s
#puts "deleting 150"
#list.delete(150)
puts "list level " + list.level.to_s
#list[100000000] = "the highest element"
puts "smallest is: " + list.smallest.to_s
puts "largest is: " + list.largest.to_s
#puts "range from 100 to 110: " + list.to_a(100,110).join(',')
def test(list)
  complete = list.to_a
  1.upto(list.level) do |l|
    #if anything in the higher layer wasn't in layer 0
    difference = list.to_a(nil,nil,nil,l) - complete
    puts "test failed level #{l} ,inconsistent node(s) #{difference}" if (difference.count != 0)
  end
  puts "test complete"
end
#puts list.to_s
#test(list) 
#list.clear

#puts "attempting to use string as key"
#list["hello"] = "world"
#puts "the output of key hello is: " + list["hello"]
