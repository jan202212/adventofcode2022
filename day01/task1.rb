#!/bin/ruby
#

INPUTFILE = "data.txt"

lines = File.read( INPUTFILE )

elvesT = lines.split( /\n\n/ )

elves = []
elvesT.each { |i| elves.append( i.split( /\n/).map(&:to_i) ) }

elvesSum = []
elves.each{ |i| elvesSum.append( i.sum() ) }

puts "Mmax: #{elvesSum.max()}"
