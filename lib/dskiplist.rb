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
module Threading
  #modify DSkipList by storing it as "base" when it includes this module
  def self.included(base)
    base::Node.class_eval do
      alias_method :old_initialize, :initialize
      def initialize(level, multi = false)
        old_initialize(level)
        @mutex = Mutex.new
        @forward = ThreadSafe::Array.new
      end
    end

    base.class_eval do
      alias_method :old_insert, :insert
      def insert *args 
        #puts 'insert wrapper used'
        old_insert *args
      end
    end
  end
end

require 'thread_safe'
require "thread/pool"
require "thread/promise"
require 'facter'
#require './threading'

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
   @pool = Thread.pool(Facter.processorcount.to_i) 
   #self.class.include Threading
  end

  
  def clear
    initialize(@max_level)
    return self
  end
    
  #returns previous node if exact key match is not found
  def find_node(search_key)
    x = @header
    @level.downto(0) do |i|
      #puts "on level #{i}"
      while x.forward[i] and x.forward[i].key < search_key
        #puts "walked node #{x.key} on level #{i}"
        x = x.forward[i]
      end
    end
    x = x.forward[0] if x.forward[0] and x.forward[0].key == search_key
    return x
  end

  def [] key
    node = self.find_node(key)
    if node and node.key == key
      return node.value
    else
      return nil
    end
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
      while x.forward[i] and x.forward[i].key < search_key
        x = x.forward[i]
      end
      update[i] = x
    end
    x = x.forward[0]
    if x and x.key == search_key
      0.upto(x.forward.length - 1) do |i|
          update[i].forward[i] = x.forward[i]
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
        end
        @level = v
      end
      x = Node.new(search_key, new_value) 
      0.upto(v) do |i|
        x.forward[i] = update[i].forward[i]
        update[i].forward[i] = x
      end
    end
    return self
  end
 
  def []= key, value
    self.insert(key, value)
  end 
  
  def insert_hash(hash)
    hash.each {|key, value| self[key] = value}
    return self
  end

  def count(from = nil, to = nil, level = 0)
    each(from, to, nil, level, nil)
  end 

  #accepts a block which is run on each element 
  def each(from=nil, to=nil, limit=nil, level=0, output=nil)
    if from 
      x = find_node(from)
      x = x.forward[level] if x.forward[level]
    else
      x = @header.forward[level]
    end
    #if no block is given, assume we are trying to count and avoid the expensive yield below
    if !block_given? 
      count = 0
      while x
        break if to && x.key >= to
        count += 1
        x = x.forward[level]
      end
      return count
    elsif to or limit
      count = 0 
      while !x.nil?
        yield(x, output) 
        count += 1
        break if to and x.key >= to 
        break if limit and count == limit 
        x = x.forward[level]
      end
    else
      while x
        yield(x, output)
        x = x.forward[level]
      end
    end
    return output
  end

  def to_h(from = nil, to = nil, limit = nil, level = 0)
    each(from, to, limit, level, {}) {|n, hash| hash[n.key] = n.value}
  end

  def to_a(from = nil, to = nil, limit = nil, level = 0)
    each(from, to, limit, level, []) {|n, arr| arr.push(n.value)}
  end
  alias_method :to_ary, :to_a

  def largest 
    x = @header
    @level.downto(0) do |i|
      while x.forward[i]
        x = x.forward[i]
      end
    end
    return x.value
  end

  def smallest 
    return @header.forward[0].value
  end

  def to_s
    str = ""
    @level.downto(0) do |l|
      str << "Level #{l}: " + to_a(nil, nil, nil, l).join('-') + "\n" 
    end
     return str 
  end  

  def to_str
    return "SkipList level #{@max_level}"
  end

  #def each(&block)
  #  self.walk(nil, nil, nil, 0, nil) @block
  #  return self
  #end

end
