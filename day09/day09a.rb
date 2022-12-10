#!/bin/ruby
#

INPUTFILE = "testdata.txt"

class Pos
  @x = 0
  @y = 0

  def initialize()
    @x = 0
    @y = 0
  end

  def up()
    @y += 1
  end

  def down()
    @y -= 1
  end

  def left()
    @x -= 1
  end

  def right()
    @x += 1
  end

  def x()
    @x
  end

  def y()
    @y
  end

  def isLeft( other )
    return other.x < @x ? @x - other.x : 0
  end

  def isRight( other )
    return other.x > @x ? other.x - @x : 0
  end

  def isHigher( other )
    return other.y > @y ? other.y - @y : 0
  end

  def isLower( other )
    return other.y < @y ? @y - other.y : 0
  end


  def follow( other )
    if other.x == @x and other.y == @y
      # nothing to be done
    elsif other.x == @x
      if isHigher( other ) > 1
        @y += 1
      elsif isLower( other ) > 1
        @y -= 1
      end
    elsif other.y == @y
      if isRight( other ) > 1
        @x += 1
      elsif isLeft( other ) > 1
        @x -= 1
      end
    else
      # diagonal
    end
  end

  def posT()
    "#{@x}, #{@y}"
  end
end

h = Pos.new
t = Pos.new

# Read input
linesT = File.read( INPUTFILE )

linesT.each_line do |lineT|
  dirT, countT = lineT.split( " " )
  count = countT.to_i

  while count > 0
    case dirT
    when "U"
      h.up
    when "D"
      h.down
    when "L"
      h.left
    when "R"
      h.right
    end

    count -= 1

    puts "#{dirT} - h: #{h.posT}  t: #{t.posT}"
    t.follow(h)
    #puts "  - h: #{h.posT}  t: #{t.posT}"

    (0..4).each do |yi|
      y = 4-yi
      (0..4).each do |x|
        if t.y == y and t.x == x
          print "T"
        elsif h.y == y and h.x == x
          print "H"
        else
          print "."
        end
      end
      puts ""
    end
    puts ""

  end


end

