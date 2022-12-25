#!/bin/ruby
#

INPUTFILE = "data.txt"

class Monkey
  @no = 0
  @items = []

  def initialize( text )
    @items = []
    @inspect_count = 0

    lines = text.split( /\n/ )
    @no = lines[0].split( " " )[1].chop
    lines.each do |l|
      t = l.split( " " )
      case t[0]
      when "Starting"
        t[2..-1].each do |i|
          addItem( i.to_i )
        end
      when "Operation:"
        @operation = t[4]
        @operand = t[5]
      when "Test:"
        @test = t[3].to_i
      when "If"
        case t[1]
        when "true:"
          @dest_true = t[5].to_i
        when "false:"
          @dest_false = t[5].to_i
        end
      end
    end

    puts "Monkey #{@no}: #{@operation} #{@operand}. Test #{@test} ? #{@dest_true}:#{@dest_false}"
  end

  def addItem( i )
    @items.append( i )
  end

  def turn?()
    @items.length > 0
  end

  def operand( old )
    @operand == "old" ? old : @operand.to_i
  end

  def round()
    old = @items.shift
    @inspect_count += 1
    newval = 0

    case @operation
    when "+"
      newval = old + operand( old )
    when "*"
      newval = old * operand( old )
    end

    return newval
  end

  def dest( worry_level )
    worry_level % @test == 0 ? @dest_true : @dest_false
  end

  def reduce( worry_level, m )
    worry_level % m.testDiv == 0 ? worry_level / m.testDiv : worry_level
  end

  def inventory()
    "Monkey #{@no}: #{@items}"
  end

  def inspectCount()
    @inspect_count
  end

  def testDiv()
    @test
  end

  def no()
    @no
  end
end


linesT = File.read( INPUTFILE )
mT = linesT.split( /\n\n/ )

monkeys = []
r = 1

mT.each do |m|
  monkey = Monkey.new( m )
  monkeys.append( monkey )
  r *= monkey.testDiv
end

puts "r: #{r} #{r == 9699690}"

10000.times do |cycle|
  puts "Cycle #{cycle+1}" if cycle % 20 == 0
  monkeys.each do |m|
    while m.turn?
      wl_old = m.round()
      wl_new = wl_old % r
      monkeys[m.dest( wl_new )].addItem( wl_new )
    end
  end

  #monkeys.each do |m|
  #  puts m.inventory()
  #end
end

inspCounts = {}
monkeys.each do |m|
  #puts "Monkey #{m.no} inspected #{m.inspectCount()} times."
  inspCounts[m] = m.inspectCount()
end

iCsort = inspCounts.sort_by( &:last ).reverse
iCsort.each do |k,v|
  puts "#{k}: #{v}"
end

puts "Solution: #{iCsort[0][1]} * #{iCsort[1][1]}"
puts "Solution: #{iCsort[0][1] * iCsort[1][1]}"

