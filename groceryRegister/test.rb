#!/usr/bin/env ruby

=begin
Testing out command line ruby using editrocket
=end

print "What is your name? "
name = gets.chomp
puts "Hello #{name}!"

File.open('grocery.rb', 'r') do |f1|  
  while line = f1.gets  
    puts line  
  end  
end  