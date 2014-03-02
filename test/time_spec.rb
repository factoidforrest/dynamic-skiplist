#require 'rspec'
require 'method_profiler'
require './lib/dskiplist'
require 'jruby/profiler'

#describe 'speedtesting' do
#  it 'insertion' do
#    @list = DSkipList.new
#
#    @profile_data = JRuby::Profiler.profile do
#      10000.times {|n| @list[n] = n}
#      puts "list count is " + @list.count
#    end
#  end
#end

def profile
  profile = MethodProfiler.observe(DSkipList)
  yield
  puts profile.report
end

def jruby_profile &block
  jprofile = JRuby::Profiler.profile &block 
  profile_printer = JRuby::Profiler::GraphProfilePrinter.new(jprofile)
  profile_printer.printProfile(STDOUT) 
end

def build_list
  list = DSkipList.new
  10000.times {|n| list[n] = n}
  return list 
end

puts "insertion"
profile {build_list}

list = build_list
puts "deletion" 
profile {10000.times{|n| list.delete[n]}

