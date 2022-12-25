#!/bin/ruby
#

INPUTFILE = "data.txt"

$mn = {} # monkeynumber
$mc = {} # monkeycalculation

def calc( monkey )
  print "Calculating #{monkey}: "
  if $mn.key?( monkey )
    #puts "number: #{$mn[monkey]}"
    $mn[monkey]
  else
    c = $mc[monkey]
    case c[:op]
    when "+"
      r = calc( c[:x] ) + calc( c[:y] )
      #print "#{c[:x]}#{c[:op]}#{c[:y]} = #{r}"
      r
    when "-"
      r = calc( c[:x] ) - calc( c[:y] )
      #print "#{c[:x]}#{c[:op]}#{c[:y]} = #{r}"
      r
    when "*"
      r= calc( c[:x] ) * calc( c[:y] )
      #print "#{c[:x]}#{c[:op]}#{c[:y]} = #{r}"
      r
    when "/"
      r = calc( c[:x] ) / calc( c[:y] )
      #print "#{c[:x]}#{c[:op]}#{c[:y]} = #{r}"
      r
    end
  end
end

linesT = File.read( INPUTFILE )

linesT.each_line do |lineT|
  monkey, value = lineT.split( ": " )
  if value.match(/^(\d)+$/)
    $mn[monkey] = value.to_i
    puts "  Value: #{monkey}: #{$mn[monkey]}"
  else
    c = {}
    c[:x], c[:op], c[:y] = value.split( " " )
    $mc[monkey] = c
    puts "  Calc:  #{monkey}: #{$mc[monkey]}"
  end
end

root = calc( "root" )
puts( "root: #{root}")
