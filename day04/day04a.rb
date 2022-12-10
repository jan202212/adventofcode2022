#!/bin/ruby
#

INPUTFILE = "data.txt"

def getRange( a )
  a.split( "-" ).map(&:to_i)
end

# check if r2 is part of r1
def contain?( r1from, r1to, r2from, r2to )
  if r1from <= r2from and r2to <= r1to
    return true
  end
  return false
end

def overlap?( r1from, r1to, r2from, r2to )
  if (r2from >= r1from and r2from <= r1to) or (r1from >= r2from and r1from <= r2to) or (r2to >= r1from and r2to <= r1to)
    return true
  end
end


lines = File.read( INPUTFILE )
contentT = lines.split( /\n/ )
contents = []
containC = 0
overlapC = 0

contentT.each do |i|
  if i.length > 0
    contents.append( i )
    r1, r2 = i.split( ',' )
    r1from, r1to = getRange( r1 )
    r2from, r2to = getRange( r2 )
    if contain?( r1from, r1to, r2from, r2to ) or contain?( r2from, r2to, r1from, r1to )
      containC += 1
    end
    if overlap?( r1from, r1to, r2from, r2to )
      overlapC += 1
    end
  end
end

puts "#{containC} contain the other range"
puts "#{overlapC} overlap"

