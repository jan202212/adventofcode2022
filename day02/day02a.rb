#!/bin/ruby
#

mapping = { "x" => "a", "y" => "b", "z" => "c" }
elementName = { "a" => "rock", "b" => "paper", "c" => "scissors"}
elementScore = { "a" => 1, "b" => 2, "c" => 3 }


WIN = 6
EQUAL = 3
LOOSE = 0

INPUTFILE = "data.txt"

# Read input
lines = File.read( INPUTFILE )
roundsT = lines.split( /\n/ )

ownDraws = []
opponentDraws = []
ownRoundResults = []
opponentRoundResults = []
ownElementScores = []
opponentElementScores = []

roundsT.each do |i|
  if i.length > 0
    opponentDraw, ownDraw = i.downcase.split( " " )
    ownDraw = mapping[ownDraw]
    opponentDraws.append( opponentDraw )
    ownDraws.append( ownDraw )
    ownElementScores.append( elementScore[ownDraw] )
    opponentElementScores.append( elementScore[opponentDraw] )
    ownRoundResult = if ownDraw == "a" and opponentDraw == "c"
                       WIN
                     elsif ownDraw == "c" and opponentDraw == "a"
                       LOOSE
                     elsif ownDraw == opponentDraw
                       EQUAL
                     elsif ownDraw > opponentDraw
                       WIN
                     else
                       LOOSE
                     end
    ownRoundResults.append( ownRoundResult )
    opponentRoundResults.append( WIN - ownRoundResult )

    puts "#{i} -> #{opponentDraw} #{ownDraw} #{elementScore[ownDraw]} + #{ownRoundResult} (#{elementName[opponentDraw]} #{elementName[ownDraw]})"
  end
end

puts "Own Element scores #{ownElementScores.sum} + round results #{ownRoundResults.sum} = score #{ownElementScores.sum + ownRoundResults.sum}"
puts "Opponent Element scores #{opponentElementScores.sum} + round results #{opponentRoundResults.sum} = score #{opponentElementScores.sum + opponentRoundResults.sum}"
