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


treesScore = Matrix.zero( forestX, forestY )

forestX.times do |xi|
  forestY.times do |yi|
    left, right, up, down = 0,0,0,0
    # left
    if xi > 0
      (xi-1..0).step(-1).each do |xi1|
        if trees[xi1,yi] >= trees[xi,yi]
          left += 1
          break
        end
        left += 1
      end
    end

    # right
    if xi < forestX-1
      (xi+1..forestX-1).each do |xi1|
        if trees[xi1,yi] >= trees[xi,yi]
          right += 1
          break
        end
        right += 1
      end
    end

    # up
    if yi > 0
      (yi-1..0).step(-1).each do |yi1|
        if trees[xi,yi1] >= trees[xi,yi]
          up += 1
          break
        end
        up += 1
      end
    end

    # down
    if yi < forestY-1
      (yi+1..forestY-1).each do |yi1|
        if trees[xi,yi1] >= trees[xi,yi]
          down += 1
          break
        end
        down += 1
      end
    end

    treesScore[xi,yi] = left*right*up*down
    if xi == 2 && yi == 1
      puts "   1,1,2,2 #{treesScore[xi,yi] == 4}"
    end
    if xi == 2 && yi == 3
      puts "   2,2,2,1 #{treesScore[xi,yi] == 8}"
    end
  end
end

treesScore.column_vectors.each do |c|
  puts "#{c}, max: #{c.max}"
end

puts "Max: #{treesScore.max}"
