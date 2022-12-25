#!/bin/ruby
#

require 'matrix'

INPUTFILE = "data.txt"

# read file
linesT = File.read( INPUTFILE )
lines = linesT.split( /\n/ )
forestX, forestY = lines[0].length, lines.length

trees = Matrix.zero( forestX, forestY )

lines.each_with_index do |line, y|
  line.each_char.each_with_index do |c, x|
    trees[x,y] = c.to_i
  end
end

treesV = Matrix.zero( forestX, forestY )

forestX.times do |x|
  max = trees[x,0]
  treesV[x,0] = 1
  (forestY-1).times do |yi|
    y = yi+1
    if trees[x,y] > max
      max = trees[x,y]
      treesV[x,y] = 1
    end
  end

  max = trees[x,forestY-1]
  treesV[x,forestY-1] = 1
  (forestY-2).times do |yi|
    y = forestY-2-yi
    if trees[x,y] > max
      max = trees[x,y]
      treesV[x,y] = 1
    end
  end
end


(forestY-2).times do |yi|
  y = yi+1
  max = trees[0,y]
  treesV[0,y] = 1
  (forestX-2).times do |xi|
    x = xi+1
    if trees[x,y] > max
      max = trees[x,y]
      treesV[x,y] = 1
    end
  end

  max = trees[forestX-1,y]
  treesV[forestX-1,y] = 1
  (forestX-2).times do |xi|
    x = forestX-2-xi
    if trees[x,y] > max
      max = trees[x,y]
      treesV[x,y] = 1
    end
  end
end


puts "Trees: "
trees.column_vectors.each do |c|
  puts c
end

puts ""
puts "Visibility: "
vCount = 0
treesV.column_vectors.each do |c|
  puts c
  vCount += c.sum
end

puts "#{vCount} trees visible, #{vCount == 21}"
