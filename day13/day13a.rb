#!/bin/ruby
#

require 'strscan'

INPUTFILE = "testdata.txt"

def parse( t )
  puts "Parsing #{t}"
  s = StringScanner.new( t )
  token = ""
  result = []
  while token = s.scan( /(\d+)+/ )
    puts "  #{token}"
  end
end


linesT = File.read( INPUTFILE )
pairsT = linesT.split( /\n\n/ )
pairsT.each do |pT|
  entriesT = pT.split( /\n/ )
  parse( entriesT[0] )
end
