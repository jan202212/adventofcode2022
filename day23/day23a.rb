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

def cpp( x, y, str )
  cpos( x, y )
  cp( str )
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
  @proposed_x = -1
  @proposed_y = -1
  @@maxx = 0
  @@maxy = 0
  @@elves_cnt = 0
  @elve_no = 0
  @@first_dir = NORTH
  @@proposed_move = {}
  @@map = {}

  def initialize( x, y )
    @x, @y = x, y
    @@elves_cnt += 1
    @elve_no = @@elves_cnt
    placeOnMap
    resetProposedMove
  end

  def setBounds( maxx, maxy )
    @@maxx = maxx > @@maxx ? maxx : @@maxy
    @@maxy = maxy > @@maxy ? maxy : @@maxy
  end

  def maxx()
    @@maxx
  end

  def maxy()
    @@maxy
  end

  def coordH( x = nil, y = nil )
    x = @x if x == nil
    y = @y if y == nil

    x + y*1000
  end

  def placeOnMap()
    @@map[ coordH ] = self
  end

  def map
    @@map
  end

  def proposedMove
    @@proposed_move
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

  def setProposedMove( x, y )
    @proposed_x, @proposed_y = x, y
  end

  def resetProposedMove()
    @proposed_x, @proposed_y = -1, -1
  end

  def getFromMap( x, y )
    @@map[ coordH( x, y ) ]
  end

  def outer( x, y )
    x < 0 || y < 0 || x > @@maxx || y > @@maxy
  end

  def free?( x, y )
    outer( x, y ) || getFromMap( x, y ) == nil
  end

  def freeAround?( x = nil, y = nil )
    x = @x if x == nil
    y = @y if y == nil

    free?( x-1, y-1 ) && free?( x, y-1 ) && free?( x+1, y-1 ) &&
      free?( x-1, y ) && free?( x, y ) && free?( x+1, y ) &&
      free?( x-1, y+1 ) && free?( x, y+1 ) && free?( x+1, y+1 )
  end

  def getFromProposedMove( x, y )
    @@proposed_move[ coordH( x, y ) ]
  end

  def draw()
    cdraw( @x, @y, @proposed_x == -1 ? '#' : "x", COLELVE )
    cdraw( @proposed_x, @proposed_y, '*'  ) if @proposed_x != -1
  end

  def newRound()
    @@proposed_move = {}
  end

  def resetMap()
    @@map = {}
  end

  def move()
    x, y = @x, @y
    move_dir = @@first_dir
    moved = false

    resetProposedMove()

    if not freeAround?
      loop do
        x, y = @x, @y
        case move_dir
        when NORTH
          if y > 0
            y -= 1
            #puts "check north #{@x},#{@y} #{free?( x-1, y )} #{free?( x, y )} #{free?( x+1, y )}"
            if x > 0 and free?( x-1, y ) and free?( x, y ) and free?( x+1, y )
              cp "move to north #{@x},#{@y}->#{x},#{y}   "
              placeProposedMove( x, y )
              setProposedMove( x, y )
              moved = true
            end
          end
        when SOUTH
          if y < @@maxy
            y += 1
            if x > 0 and free?( x-1, y ) and free?( x, y ) and free?( x+1, y )
              cp "move to south #{@x},#{@y}->#{x},#{y}   "
              placeProposedMove( x, y )
              moved = true
              setProposedMove( x, y )
            end
          end
        when WEST
          if x > 0
            x -= 1
            if y > 0 and free?( x, y-1 ) and free?( x, y ) and free?( x, y+1 )
              cp "move to east #{@x},#{@y}->#{x},#{y}   "
              placeProposedMove( x, y )
              moved = true
              setProposedMove( x, y )
            end
          end
        when EAST
          if x < @@maxx
            x += 1
            if y > 0 and free?( x, y-1 ) and free?( x, y ) and free?( x, y+1 )
              cp "move to west #{@x},#{@y}->#{x},#{y}   "
              placeProposedMove( x, y )
              moved = true
              setProposedMove( x, y )
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
      if @@proposed_move[ coordH( @proposed_x, @proposed_y )] != nil && @@proposed_move[ coordH( @proposed_x, @proposed_y )].length > 1
        @@proposed_move[ coordH( @proposed_x, @proposed_y ) ].each do |e|
          e.resetProposedMove
        end
        @@proposed_move[ coordH( @proposed_x, @proposed_y ) ] = nil
      else
        @x, @y = @proposed_x, @proposed_y
        resetProposedMove
      end
    end
    placeOnMap
  end


  def to_s()
    "Elve #{@elve_no} #{@x},#{@y} #{@proposed_x != -1 ? @proposed_x : ''} #{@proposed_y != -1 ? @proposed_y : ''}"
  end
end


def clrMap(e)
  (0..e.maxy).each do |l|
    (0..e.maxx).each do |c|
      cpos l,c
      cp "."
    end
    Curses.clrtoeol
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


  clrMap( elves[0] )
  elves.each do |e|
    e.draw
  end

  cpp( 35, 0, "#{elves[0].map}" )

  Curses.getch

  round_no_wait = false

  10.times do |i|
    elves[0].resetProposedMoveMap

    elves.each do |e|
      e.move
      elves.each do |e1|
        e1.draw
      end
      cpos 30,0
      cp "Round #{i}, #{e}"
      if round_no_wait == false
        case Curses.getch
        when "q"
          break
        when "f"
          round_no_wait = true
        end
      end
    end


    elves[0].resetMap

    elves.each do |e|
      e.finalizeRound
    end

    clrMap( elves[0] )

    elves.each do |e|
      e.draw
    end

    cpp( 30, 0, "Round #{i} Finalized, #{elves[0].proposedMove},  #{elves[0].map}" )
    cpp( 35, 0, "#{elves[0].map}" )

    break if Curses.getch == "q"
  end


  while Curses.getch != "q"
  end
ensure
  Curses.close_screen
end
