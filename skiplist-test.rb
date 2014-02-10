require './skiplist.rb'
require 'benchmark'
require 'skiplist'
list = DSkipList.new
otherList = SkipList.new 100
hash = {}
Benchmark.bm(20) do |b| 
  b.report('Insert time: ') {1.upto(10000) {|i| list[i] = i}}
  #b.report('Other list insert: ') {1.upto(10000) {|i| otherList[i] = i}}
  b.report('Search time: ') {1.upto(10000) {|i| list[i]}}
  #b.report('Other list search: ') {1.upto(10000) {|i| otherList[i]}}
  #b.report('List +million: ') {10000.upto(1010000) {|i| list[i] = i}}
  #b.report('Hash +million: ') {1.upto(1000000) {|i| hash[i] = i}}
  #b.report('List search 10000') {1000000.upto(1010000) {|i| list[i]}}
  #b.report('Hash search 10000') {900000.upto(1000000) {|i| hash[i]}}
  #b.report('List +10000: ') {1040000.upto(1050000) {|i| list[i] = i}}
  #b.report('Search time: ') {1000000.upto(1010000) {|i| list[i]}}
end
puts "list size: " + list.count.to_s
puts "deleting 150"
list.delete(150)
puts "list level " + list.level.to_s
list[100000000] = "value"
puts "large number reads: " + list[100000000].to_s
puts "lowest is: " + list.lowest.to_s
puts "highest is: " + list.highest.to_s
puts "range from 100 to 110: " + list.to_a(0,100,110, 5).join(',')
def test(list)
  complete = list.to_a
  1.upto(list.level) do |l|
    #if anything in the higher layer wasn't in layer 0
    difference = list.to_a(l) - complete
    puts "test failed level #{l} ,inconsistent node(s) #{difference}" if (difference.count != 0)
  end
  puts "test complete"
end
#test(list) 
list.clear

puts "attempting to use string as key"
list["hello"] = "world"
puts "the output of key hello is: " + list["hello"]
