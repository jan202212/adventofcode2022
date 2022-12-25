#!/bin/ruby
#

require 'matrix'
require 'curses'

INPUTFILE = "data.txt"

RIGHT, DOWN, LEFT, UP = 0, 1, 2, 3
NONE, FREE, BLOCK = 0, 1, 2

DIR_ARR = [ ">", "v", "<", "^" ]
DIR_T = [ "right", "down", "left", "up"]

WX = 60
WY = 15

$winposX = 1
$winposY = 1
$winposX2 = WX*2
$winposY2 = WY*2

COLNORM = 1
COLTRACE = 2

# Curses wrapper
def cp( str )
  Curses.addstr str
end

def cpos( y, x )
  Curses.setpos( y, x )
end

def calc_winpos( p, sizeX, sizeY )
  $winposX = p[0] > WX ? p[0] - WX : 1
  $winposY = p[1] > WY ? p[1] - WY : 1

  $winposX2 = $winposX + WX*2
  $winposX2 = $winposX2 > sizeX ? sizeX : $winposX2
  $winposY2 = $winposY + WY*2
  $winposY2 = $winposY2 > sizeY ? sizeY : $winposY2
end


sizeX, sizeY = 0, 0

def wrap( val, size )
  val = val >= size ? 1 : val
  val = val < 1 ? size-1 : val

  val
end

def draw( x, y, chr, col = nil )
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


def go( m, p, dir, count )
  x, y = p[0], p[1]
  nx, ny = x, y
  sizeX, sizeY = m.row_count, m.column_count

  dx, dy = case dir
           when RIGHT
             [1,0]
           when DOWN
             [0,1]
           when LEFT
             [-1,0]
           when UP
             [0,-1]
           end

  draw( x, y, "x", COLTRACE )

  count.times do
    # find next place on map (no place out of the map)
    nx, ny = x, y
    loop do
      nx = nx + dx
      ny = ny + dy
      # check wrapping
      nx = wrap( nx, sizeX )
      ny = wrap( ny, sizeY )
      # find next free field
      break if m[nx,ny] != NONE
    end
    # store new pos, if no BLOCK was hit
    if m[nx,ny] == FREE
      x, y = nx, ny
    end
    #print_matrix( m, [x,y] )

    draw( x, y, "#{DIR_ARR[dir]}", COLTRACE )
  end
  draw( x, y, "X", COLTRACE )
  [x,y]
end

def print_matrix( m, p )
  sizeX, sizeY = m.row_count + 1, m.column_count + 1

  (1..sizeY).each do |y|
    (1..sizeX).each do |x|
      if( x == p[0] && y == p[1] )
        draw( x, y, "x" )
      else
        case m[x,y]
        when NONE
          draw( x, y, ' ' )
        when FREE
          draw( x, y, '.' )
        when BLOCK
          draw( x, y, '#' )
        end
      end
    end
    Curses.clrtoeol
  end
end


linesT = File.read( INPUTFILE )
mapT, routeT = linesT.split( /\n\n/ )

#determin matrix size
mapT.each_line do |lineT|
  sizeY += 1
  sizeX = ( sizeX >= lineT.length ? sizeX : lineT.length )
end

$m = Matrix.zero( sizeX+1, sizeY+1 )

x, y = 0, 0
mapT.each_line do |lineT|
  y += 1
  x = 0
  lineT.each_char do |c|
    x += 1
    $m[x,y] = case c
    when "."
      1
    when '#'
      2
    else
      0
    end
  end
end

puts "#{$m.row_count}, #{$m.column_count}, #{sizeX}, #{sizeY}"

p = [1,1]
while $m[p[0],p[1]] != 1
  p[0] += 1
end

#print_matrix( $m, p )
dir = RIGHT

Curses.init_screen
Curses.start_color
Curses.init_pair( COLNORM, 7, 0 )
Curses.init_pair( COLTRACE, 3, 0 )
Curses.noecho

cpos( WY*2 + 3, 0)
cp "Map size #{sizeX},#{sizeY}"

auto = false
sleeptime = 0.2

begin
  routeT1 = routeT
  while routeT1 != nil && routeT1.length > 0
    m = routeT1.match /(\d+)([RL])?(.*)/
    cnt, chdir, r = m[1], m[2], m[3]

    cpos( WY*2 + 1, 0)
    cp "#{cnt} times #{DIR_T[dir]}, rest #{r[0,10]}, routelen #{r.length}"
    Curses.clrtoeol

    calc_winpos( p, sizeX, sizeY )
    print_matrix( $m, p )

    np = go( $m, p, dir, cnt.to_i )
    routeT1 = r

    cpos( WY*2 + 2, 0)
    cp "#{dir}: #{p} -> #{np}"
    Curses.clrtoeol
    p = np

    dir = case chdir
          when "R"
            dir >= UP ? RIGHT : dir + 1
          when "L"
            dir <= RIGHT ? UP : dir - 1
          else
            dir
          end

    Curses.refresh
    if not auto
      case Curses.getch
      when "q"
        break
      when "f"
        auto = true
      when "F"
        auto = true
        sleeptime = 0.005
      end
    else
      sleep( sleeptime )
    end
  end

  cpos( WX*2 + 3, 0)
  cp "row #{p[0]}, col #{p[1]}, dir #{dir}  - password #{p[1] * 1000 + p[0] * 4 + dir}"
  while Curses.getch != "q"
  end
ensure
  Curses.close_screen
end

