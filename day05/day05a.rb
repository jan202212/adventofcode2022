#!/bin/ruby
#

INPUTFILE = "data.txt"

stacks = []
stackParses = []

def getTops( stacks )
  a = []
  stacks.each do |i|
    a.append( i.last )
  end

  a
end

# read file
lines = File.read( INPUTFILE )
stacksParseT, instructionsT = lines.split( /\n\n/ )
stacksParse = stacksParseT.split( /\n/ )

# build stacks
stacksParse.reverse.each_with_index do |x, i|
  if i > 0
    for stackNo in 0..x.length/4
      item = x[stackNo*4+1]
      if item != ' '
        stacks[stackNo] = [] if stacks[stackNo] == nil
        stacks[stackNo].append( item )
      end
    end
  end
end

puts "initial stacks:"
stacks.each do |i|
  puts "#{i}"
end

# follow instructions
instructionsT.each_line do |i|
  w1, cnt, w2, from, w3, to = i.split
  cnt.to_i.times do
    stacks[to.to_i-1].push( stacks[from.to_i-1].pop )
  end
end


# result
puts "final stacks:"
stacks.each do |i|
  puts "#{i}"
end

puts "Result #{getTops( stacks )}"

puts "Result as string: #{getTops( stacks ).join}"
