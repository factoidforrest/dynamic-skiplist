require 'skiplist.rb'

list = SkipList.new 10

list.insert 2 , "duck"
list.insert 5 , "goose"
list.insert 7 , "cat"

puts list.search(5).value
x = list.header
while x && x.forward[0] != nil
	puts "Traversing node: " 
	puts x.key
	puts "the node's links are: " , x.forward
	x = x.forward[0]
end