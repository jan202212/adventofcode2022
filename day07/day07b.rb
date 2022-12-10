#!/bin/ruby
#

INPUTFILE = "data.txt"

$delcandidate = {:elem => nil, :size => 0, :name => ""}

def is_dir?( entry )
  return entry != nil && entry.is_a?(Hash)
end

def dir_size( dir )
  size = 0
  dir.each do |k, x|
    if is_dir?(x)
      size += dir_size( x )
    else
      size += x
    end
  end

  return size
end


def size_sum( dir, minsize )
  size_curr = 0
  dir.each do |k, x|
    if is_dir?(x)
      s = size_sum( x, minsize )
      if s >= minsize && ( $delcandidate[:elem] == nil || $delcandidate[:size] > s )
        $delcandidate[:elem] = x
        $delcandidate[:size] = s
        $delcandidate[:name] = k
      end
      size_curr += s
    else
      size_curr += x
    end
  end

  return size_curr
end


fsroot = Hash.new()
fscurr = fsroot
fspath = []

# init fspath
fspath.append( fsroot )

# Read input
linesT = File.read( INPUTFILE )

linesT.each_line do |lineT|
  line = lineT.split( " " )
  if line[0] == '$'
    case line[1].downcase
    when "cd"
      case line[2]
      when "/"
        fscurr = fsroot
      when ".."
        puts "is already at root level" if fscurr == fsroot
        fscurr = fspath.pop
      else
        fscurr[line[2]] = Hash.new()
        fspath.append( fscurr )
        fscurr = fscurr[line[2]]
      end
    end
  else
    if line[0] != "dir"
      # ignore directories, just store file sizes
      fscurr[line[1]] = line[0].to_i
    end
  end
end

fssize = dir_size(fsroot)
fsfree = 70000000 - fssize
fsneeded = 30000000 - fsfree
puts "file system size #{fssize} #{fssize == 48381165}"
puts "additional space needed #{fsneeded} #{fsneeded == 8381165}"
puts "Sum of sizes #{size_sum(fsroot, fsneeded)}"

puts "Candidate to delete #{$delcandidate[:name]} with size #{$delcandidate[:size]}, #{$delcandidate[:size] > fsneeded}"
