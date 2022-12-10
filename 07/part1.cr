#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Directory
  property children = {} of String => Directory
  property files = [] of NamedTuple(size: Int32, name: String)
  @@root = Directory.new
  @@dir_path = [] of Directory

  def size : Int32
    return files.sum{|e| e[:size]} + children.values.sum{|e| e.size}
  end

  def scan
    if children.size == 0
      return [self]
    else
      return [self] + children.map{|k,v| v.scan}.flatten
    end
  end

  def self.root
    @@root
  end

  def self.root=(val)
    @@root = val
  end

  def self.dir_path
    @@dir_path
  end

  def self.dir_path=(val)
    @@dir_path = (val)
  end
end

def current_dir
  if Directory.dir_path.empty?
    return Directory.root
  else
    return Directory.dir_path.last
  end
end

def change_dir(target)
  case target
  when ".."
    Directory.dir_path.pop
  when "/"
    Directory.dir_path.clear
  else
    if dir = current_dir.children[target]?
      Directory.dir_path.push(dir)
    else
      current_dir.children[target] = Directory.new
      Directory.dir_path.push(current_dir.children[target])
    end
  end
end

input.lines.each do |line|
  if line[0] == '$'
    values = line[2..-1].split(' ')
    command = values[0]
    args = values[1..-1]?
    assert args.nil? == false
    if args && !args.empty?
      assert args.size > 0
      change_dir(args[0])
    end
  else
    values = line.split(' ')
    assert values.size == 2
    if values[0] == "dir"
      # i dont think there needs to be anything here
    else
      file = {size: values[0].to_i, name: values[1]}
      assert current_dir.files.includes?(file) == false
      current_dir.files << file
    end
  end
end

puts Directory.root.scan.map{|e| e.size}.reject{|e| e > 100000}.sum
