#!/bin/ruby
#

require "bases"

INPUTFILE = "testdata.txt"

DIGITS = {
  "=" => -2,
  "-" => -1,
  "0" =>  0,
  "1" =>  1,
  "2" =>  2
}

def snafu_to_i( str )
  str_r = str.reverse

  number = 0
  idx = 0

  str_r.each_char do |c|
    number += DIGITS[c] * (5**idx)
    idx += 1
  end

  number
end

def i_to_snafu( number )
  b5 = Bases.val( number.to_s ).in_base( 10 ).to_base( 5 )
  puts( "#{number} => b5: #{b5}")
end


linesT = File.read( INPUTFILE )


sum = 0

linesT.each_line do |lineT|
  t = lineT.strip
  n = snafu_to_i( t )
  sum += n
  puts "#{t} => #{n}"
end

puts "Sum: #{sum}"
