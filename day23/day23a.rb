#!/bin/ruby
#

require 'matrix'
require 'curses'

INPUTFILE = "testdata.txt"

elves = []
NORTH, SOUTH, WEST, EAST, MAXDIR = 0, 1, 2, 3, 4

COLNORM = 1
COLELVE = 2
$winposX = 0
$winposY = 0
$winposX2 = 80
$winposY2 = 30


# Curses wrapper
def cp( str )
  Curses.addstr str
end

def cpos( y, x )
  Curses.setpos( y, x )
end

def cdraw( x, y, chr, col = nil )
  if x >= $winposX && x <= $winposX2 && y >= $winposY && y <= $winposY2
    if col != nil
      Curses.attrset( Curses.color_pair( col ) )
    end

    cpos y - $winposY, x - $winposX
    cp "#{chr}"

    if col != nil
      Curses.attrset( Curses.color_pair( COLNORM ) )
    end
  end
end


class Elve
  @x = 0
  @y = 0
  @proposed_x = 0
  @proposed_y = 0
  @@maxx = 0
  @@maxy = 0
  @@elves_cnt = 0
  @@first_dir = NORTH
  @@proposed_move = {}
  @@map = {}

  def initialize( x, y )
    @x, @y = x, y
  end

  def setBounds( maxx, maxy )
    @@maxx = maxx > @@maxx ? maxx : @@maxy
    @@maxy = maxy > @@maxy ? maxy : @@maxy
  end

  def coordH( x = nil, y = nil )
    x = @x if x == nil
    y = @y if y == nil

    x + y*1000
  end

  def placeOnMap()
    @@map[ coordH ] = self
  end

  def placeProposedMove( x, y )
    @@proposed_move[ coordH( x, y ) ] = [] if @@proposed_move[ coordH( x, y ) ] == nil
    @@proposed_move[ coordH( x, y ) ].append( self )
  end

  def resetProposedMoveMap()
    (0..@@maxx).each do |x|
      (0..@@maxy).each do |y|
        @@proposed_move[ coordH( x, y ) ] = nil
      end
    end
  end

  def resetProposedMove()
    @proposed_x, @proposed_y = -1, -1
  end

  def getFromMap( x, y )
    @@map[ coordH( x, y ) ]
  end

  def free?( x, y )
    getFromMap( x, y ) == nil
  end

  def freeAround?( x = nil, y = nil )
    x = @x if x == nil
    y = @y if y == nil

    @@map[ coordH( x-1, y-1 )] == nil and @@map[ coordH( x, y-1 )] == nil and @@map[ coordH( x+1, y-1 )] == nil and
      @@map[ coordH( x-1, y )] == nil and @@map[ coordH( x, y )] == nil and @@map[ coordH( x+1, y )] == nil and
      @@map[ coordH( x-1, y+1 )] == nil and @@map[ coordH( x, y+1 )] == nil and @@map[ coordH( x+1, y+1 )] == nil
  end

  def getFromProposedMove( x, y )
    @@proposed_move[ coordH( x, y ) ]
  end

  def draw()
    cdraw( @x, @y, '#', COLELVE )
  end

  def newRound()
    @@proposed_move = {}
  end

  def move()
    x, y = @x, @y
    move_dir = @@first_dir
    moved = false

    resetProposedMove()

    if not freeAround?
      loop do
        case move_dir
        when NORTH
          if y > 0
            y -= 1
            if x > 0 and free?( x-1, y ) and free?( x, y ) and free?( x+1, y )
              placeProposedMove( x, y )
              @proposed_x, @proposed_y = x, y
              moved = true
            end
          end
        when SOUTH
          if y < @maxy
            y += 1
            if x > 0 and free?( x-1, y ) and free?( x, y ) and free?( x+1, y )
              placeProposedMove( x, y )
              moved = true
              @proposed_x, @proposed_y = x, y
            end
          end
        when EAST
          if x > 0
            x -= 1
            if y > 0 and free?( x, y-1 ) and free?( x, y ) and free?( x, y+1 )
              placeProposedMove( x, y )
              moved = true
              @proposed_x, @proposed_y = x, y
            end
          end
        when WEST
          if x < @maxx
            x += 1
            if y > 0 and free?( x, y-1 ) and free?( x, y ) and free?( x, y+1 )
              placeProposedMove( x, y )
              moved = true
              @proposed_x, @proposed_y = x, y
            end
          end
        end

        ## next direction
        move_dir += 1
        move_dir = 0 if move_dir == MAXDIR
        break if move_dir == @@first_dir or moved
      end
    end
  end

  def finalizeRound
    if @proposed_x != -1
      if @@proposed_move[ coordH( @proposed_x, @proposed_y )].length > 1
        @@proposed_move[ coordH( @proposed_x, @proposed_y ) ].each do |e|
          e.resetProposedMove
        end
        @@proposed_move[ coordH( @proposed_x, @proposed_y ) ] = nil
      else
        @x, @y = @proposed_x, @proposed_y
        resetProposedMove
      end
    end
  end
end



# Curses
Curses.init_screen
Curses.start_color
Curses.init_pair( COLNORM, 7, 0 )
Curses.init_pair( COLELVE, 3, 0 )
Curses.noecho

# main
x, y = 0, 0

begin
  linesT = File.read( INPUTFILE )
  linesT.each_line do |lineT|
    x = 0
    elves[0].setBounds( lineT.length, y ) if elves[0] != nil
    lineT.each_char do |c|
      case c
      when '#'
        e = Elve.new(x, y)
        elves.append( e )
      end
      x += 1
    end
    y += 1
  end

  elves.each do |e|
    e.draw
  end

  10.times do |i|
    elves[0].resetProposedMoveMap

    elves.each do |e|
      e.move
    end

    elves.each do |e|
      e.finalizeRound
    end

    elves.each do |e|
      e.draw
    end

    cpos 30,0
    cp "Round #{i}"

    Curses.getch
  end


  while Curses.getch != "q"
  end
ensure
  Curses.close_screen
end
