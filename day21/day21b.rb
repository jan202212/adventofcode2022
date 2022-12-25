#!/bin/ruby
#

INPUTFILE = "data.txt"

STOP = "humn"


$mn = {} # monkeynumber
$mc = {} # monkeycalculation

def calc( monkey, stop )
  if monkey == stop
    return nil
  end
  if $mn.key?( monkey )
    $mn[monkey]
  else
    c = $mc[monkey]
    x = calc( c[:x], stop )
    y = calc( c[:y], stop )
    if x == nil || y == nil
      return nil
    end
    case c[:op]
    when "+"
      x + y
    when "-"
      x - y
    when "*"
      x * y
    when "/"
      x / y
    end
  end
end

def calct( monkey, t, stop )
  if monkey == stop
    puts "#{stop} = #{t}"
  else
    if $mn.key?( monkey )
      #$mn[monkey]
      puts "#{monkey} ?"
    else
      c = $mc[monkey]
      left = calc( c[:x], stop )
      right = calc( c[:y], stop )
      if left == nil
        case c[:op]
        when "+"
          calct( c[:x], t - right, stop )
        when "-"
          calct( c[:x], t + right, stop )
        when "*"
          calct( c[:x], t / right, stop )
        when "/"
          calct( c[:x], t * right, stop )
        end
      elsif right == nil
        case c[:op]
        when "+" # t = a-b  -> -b = t-a  -> b = a-t
          calct( c[:y], t - left, stop )
        when "-"
          calct( c[:y], left-t, stop )
        when "*"
          calct( c[:y], t / left, stop )
        when "/"
          calct( c[:y], t * left, stop )
        end
      end
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

root = $mc["root"]
puts "Calculating left wing: #{root[:x]}"
left = calc( root[:x], STOP)

puts "Calculating right wing: #{root[:y]}"
right = calc( root[:y], STOP)

if left == nil
  puts "Human on left wing, target value #{right}"
  calct( root[:x], right, STOP)
elsif right == nil
  puts "Human on right wing, target value #{left}"
  calct( root[:y], left, STOP)
end
