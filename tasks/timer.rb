['2.1', 'jruby', 'rbx'].each do |version| 
  `~/.rvm/bin/rvm-exec #{version} ruby skiplist-test.rb`
  puts version
end
