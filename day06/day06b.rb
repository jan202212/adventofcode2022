#!/bin/ruby
#

INPUTFILE = "data.txt"

def repeating_char( str )
  if str.length <= 1
    return false
  end

  (str.length-1).times do |i|
    if str[0] == str[i+1]
      return true
    end
  end

  return repeating_char( str[1..-1] )
end

# Read input
line = File.read( INPUTFILE )

(line.length-14).times do |i|
  if not repeating_char( line[i,14] )
    puts "Start of packet at #{i+14}"
    break
  end
end

