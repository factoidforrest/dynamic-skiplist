require './skiplist.rb'


list = SkipList.new

1.upto(200) {|i| list.insert(i)}
50.upto(150) {|i| list.delete(i)}
list.insert(25, "fish")

#puts list.to_a
puts list.search(101)
puts list.to_s

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
