#!/bin/ruby
#

INPUTFILE = "data.txt"

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


def size_sum( dir, maxsize )
  size_curr = 0
  size_children = 0
  dir.each do |k, x|
    if is_dir?(x)
      size_curr += dir_size(x)
      size_children += size_sum( x, maxsize )
    else
      size_curr += x
    end
  end

  return ((size_curr <= maxsize || maxsize == 0) ? size_curr : 0) + size_children
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

puts "file system size #{dir_size(fsroot)} #{dir_size(fsroot) == 48381165}"
puts "Sum of sizes #{size_sum(fsroot, 100000)}"
