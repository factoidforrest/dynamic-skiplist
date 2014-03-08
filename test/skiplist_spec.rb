#Be sure to run 'gem install dskiplist --development' before running 
#require 'method_profiler'
require 'rspec'
require './lib/dskiplist.rb'
require 'pry' 

#Checks for stray links in the upper levels. There may be a more exhaustive way to check integrity. 
def check_integrity(list)
  complete = list.to_a
  1.upto(list.level) do |l|
    #if anything in the higher layer wasn't in layer 0
    layer = list.to_a(nil,nil,nil,l)
    difference = (layer - complete)
    puts "stray node found in level: #{l} which is #{list.to_a(nil,nil,nil,l)}" if !difference.empty? 
    expect(difference).to match_array([])
  end
end

describe "The skiplist" do

  puts "test suite launching"
  before :each do
    @list = DSkipList.new(nil, false)
    100.times {|n| @list[n] = n}
  end
  after :each do
    check_integrity(@list)
  end 

  it "sets up the observer", :time => true do
    #@profiler = MethodProfiler.observe(@list)
  end

  it "should lookup value correctly" do
    expect(@list[30]).to eq(30)
  end

  it "should overwrite value with identical key" do
    @list[25] = "walrus"
    expect(@list[25]).to eq("walrus")
  end

  it "should count correctly" do
    expect(@list.count).to eq(100)
    expect(@list.count(50,99)).to eq(48)
    expect(@list.count(1,1)).to eq(0)
  end

  it "should convert to array" do
    entire = @list.to_a
    expect(entire.count).to eq(100)
    subset = @list.to_a(25,50)
    expect(subset.count).to eq(25)
    26.upto(50) do |n|
      expect(subset.include? n).to eq(true)
    end
  end

  it "should return nil if key not found" do
    expect(@list[99999999989].nil?).to eq(true)
  end
  it "should convert to hash" do
    expect(@list.to_h.count).to eq(100)
    expect(@list.to_h(50,75).count).to eq(25)
    subset = @list.to_h(25,50)
    26.upto(50) do |n|
      expect(subset[n]).to eq(n)
    end 
  end

  it "should delete one element properly" do
    @list.delete 25
    expect(@list[25]).to eq(nil)
  end

  it "should delete multiple elements properly" do 
    (25..75).each {|n| @list.delete n}
    (25..75).each {|n| expect(@list[n]).to eq(nil)}
    #check sizes of each level to make sure we aren't chopping off the tail when we delete.  Seems fine
    #@list.level.downto(0) {|l| puts "level #{l} contains #{@list.count(nil, nil, l)}"}
  end

  it "should accept a block" do
    object_count = 0 
    @list.each { object_count +=1 } 
    expect(object_count).to eq(100)
  end
 
  it "reports the observer", :time => true do
    #puts @profiler.report
  end
end
