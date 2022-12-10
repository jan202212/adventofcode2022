#!/bin/ruby
#

INPUTFILE = "data.txt"
GROUPCNT = 3

ASCII_A = 'A'.ord
ASCII_a = 'a'.ord

def findCommonItem( a, b )
  a.each do |x|
    b.each do |y|
      if x == y
        return x
      end
    end
  end

  return 0 # should not...
end

def findCommonItem3( a, b, c )
  a.each do |x|
    b.each do |y|
      c.each do |z|
        if x == y and x == z
          return x
        end
      end
    end
  end

  return 0 # should not...
end

def getPrio( a )
  if a >= 'A' and a <= 'Z'
    a.ord - ASCII_A+27
  else
    a.ord - ASCII_a+1
  end
end


lines = File.read( INPUTFILE )

contentT = lines.split( /\n/ )

contents, compAs, compBs, commonItems, priorities = [], [], [], [], []

contentT.each do |i|
  if i.length > 0
    contents.append( i )
    half = i.length/2
    compAT, compBT = i.scan( /.{#{half}}/ )
    compA = compAT.split( '' )
    compB = compBT.split( '')
    compAs.append( compA )
    compBs.append( compB )
    commonItem = findCommonItem( compA, compB )
    commonItems.append( commonItem )
    priorities.append( getPrio( commonItem ) )

    puts "#{i} -> #{compAT} + #{compBT} -> #{commonItem} (#{getPrio(commonItem)})"
  end
end

puts "Sum of priorities #{priorities} = #{ priorities.sum }"

# Part 2
commonItemInGroups, commonItemInGroupPrios = [], []
(contentT.length/GROUPCNT).times do |i|
  commonItemInGroup = findCommonItem3( contentT[i*GROUPCNT].split(''), contentT[i*GROUPCNT+1].split(''), contentT[i*GROUPCNT+2].split('') )
  prio = getPrio( commonItemInGroup )
  commonItemInGroups.append( commonItemInGroup )
  commonItemInGroupPrios.append( prio )
  puts "Group #{i} commonItemInGroup #{commonItemInGroup} (#{prio})"
end

puts "Sum of the priorities of those item types: #{commonItemInGroupPrios.sum}"
