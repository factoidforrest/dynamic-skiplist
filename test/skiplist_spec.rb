require 'rspec'
require 'dskiplist'
#Checks for stray links in the upper levels. There may be a more exhaustive way to check integrity. 
def check_integrity(list)
  complete = list.to_a
  1.upto(list.level) do |l|
    #if anything in the higher layer wasn't in layer 0
    difference = list.to_a(nil,nil,nil,l) - complete
    puts "stray node found in level: #{l} which is #{list.to_a(nil,nil,nil,l)}" if !difference.empty? 
    expect(difference).to match_array([])
  end
end

describe "The skiplist" do
  before :each do
    @list = DSkipList.new
    100.times {|n| @list[n] = n}
  end
  after :each do
    check_integrity(@list)
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
    expect(@list.count(50,99)).to eq(50)
    expect(@list.count(1,1)).to eq(1)
  end

  it "should convert to array" do
    entire = @list.to_a
    expect(entire.count).to eq(100)
    subset = @list.to_a(26,50)
    expect(subset.count).to eq(25)
    26.upto(50) do |n|
      expect(subset.include? n).to eq(true)
    end
  end

  it "should convert to hash" do
    expect(@list.to_h.count).to eq(100)
    expect(@list.to_h(51,75).count).to eq(25)
    subset = @list.to_h(25,50)
    25.upto(50) do |n|
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
  end
end
