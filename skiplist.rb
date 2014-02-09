=begin
The MIT License (MIT)

Copyright (c) 2014 Forrest Allison

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
=end
 
class DSkipList
  attr_accessor :level
  attr_accessor :header
  include Enumerable

  class Node
    attr_accessor :key
    attr_accessor :value
    attr_accessor :forward
 
    def initialize(k, v = nil)
      @key = k 
      @value = v.nil? ? k : v 
      @forward = []
    end
  end

  def initialize(top_level = Float::INFINITY)
   @header = Node.new(1) 
   @level = 0
   @max_level = top_level
   @p = 0.5
   @node_nil = Node.new(1000000)
   @header.forward[0] = @node_nil
  end

  def clear
    initialize(@max_level)
    return self
  end

  def find_node(search_key)
    x = @header
    @level.downto(0) do |i|
      while x.forward[i] and x.forward[i].key < search_key
        x = x.forward[i]
      end
    end 
    x = x.forward[0]
    if x.key == search_key
      return x
    else
      return nil
    end
  end
  
  def [] key
    node = self.find_node(key)
    return node.value if node
  end 

  def random_level
    v = 0
    while rand < @p && v < @max_level
      v += 1
    end
    v
  end

  def delete(search_key)
    update = []
    x = @header
    @level.downto(0) do |i|
      while x.forward[i].key < search_key
        x = x.forward[i]
      end
      update[i] = x
    end
    x = x.forward[0]
    if x.key == search_key
      0.upto(x.forward.length - 1) do |i|
        update[i].forward[i] = x.forward[i] if x.forward[i]
      end
      return true
    else
      return false
    end
  end

  def insert(search_key, new_value = nil)
    new_value = search_key if new_value.nil? 
    update = []
    x = @header
    @level.downto(0) do |i|
      while x.forward[i] and x.forward[i].key < search_key
        x = x.forward[i]
      end
      update[i] = x
    end   
    x = x.forward[0]
    if x and x.key == search_key
      x.value = new_value
    else
      v = random_level
      if v > @level
        (@level + 1).upto(v) do |i|
          update[i] = @header
          #@header.forward[i] = nil 
        end
        @level = v
      end
      x = Node.new(search_key, new_value) 
      0.upto(v) do |i|
        x.forward[i] = update[i].forward[i]
        update[i].forward[i] = x
      end
    end
  end
 
  def []= key, value
    self.insert(key, value)
  end 

  def to_a(l = 0)
    x = @header.forward[l]
    a = []
    while x.forward[l]
      a << x.value
      x = x.forward[l]
    end
    a
  end
  alias_method :to_ary, :to_a

  def to_s
    str = ""
    @level.downto(0) do |l|
      str << "Level #{l}: " + to_a(l).join('-') + "\n" 
    end
     return str 
  end  

  def to_str
    return "SkipList level #{@max_level}"
  end

  def each(&block)
    self.to_a.each(&block)
  end

end

