require 'skiplist.rb'

def print_list(list)
  x = list.header
  while x && x.forward[0] != nil
    puts "Traversing node: " 
    puts x.key
    puts "the node's links are: " , x.forward
    x = x.forward[0]
  end
end

list = SkipList.new 10

1.upto(200) do |i|
  list.insert(i)
end
list.delete 100
list.delete 50
list.delete 25
list.insert(25, "fish")

puts list.to_a
puts list.search(101)
