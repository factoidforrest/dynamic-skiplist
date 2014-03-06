['2.1', 'jruby', 'rbx'].each do |version| 
  `~/.rvm/bin/rvm-exec #{version} --verbose pwd`
  puts version
end
