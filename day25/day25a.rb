#!/bin/ruby
#

require "bases"

INPUTFILE = "data.txt"

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
  #puts( "#{number} => b5: #{b5}")
  str_r = b5.reverse
  str_rn = ""
  carry = 0
  str_r.each_char do |c|
    i = c.to_i
    i += carry
    nc = "#{i.to_s}"
    carry = 0
    case i
    when 3
      carry = 1
      nc = "="
    when 4
      carry = 1
      nc = "-"
    when 5
      carry = 1
      nc = "0"
    end
    str_rn += "#{nc}"
  end

  if carry > 0
    str_rn += "#{carry}"
  end
  str_rn.reverse
end


linesT = File.read( INPUTFILE )


sum = 0

linesT.each_line do |lineT|
  t = lineT.strip
  n = snafu_to_i( t )
  sum += n
  puts "#{t} => #{n}  (sum: #{sum})"
end

s = i_to_snafu( sum )
puts "Sum: #{sum} => #{s}"

#puts "Testdata"
#[3,4,8,9,15,20,2022,12345,314159265].each do |n|
#  puts "  #{n} => #{i_to_snafu( n )}"
#end
