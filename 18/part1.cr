#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

cubes = input.lines.map(&.split(",").map(&.to_i))

space = {} of Tuple(Int32, Int32, Int32) => Bool

area = 0

cubes.each do |cube|
  space[{cube[0], cube[1], cube[2]}] = true
end

space.keys.each do |x,y,z|
  area += 1 unless space[{x+1,y,z}]?
  area += 1 unless space[{x-1,y,z}]?
  area += 1 unless space[{x,y+1,z}]?
  area += 1 unless space[{x,y-1,z}]?
  area += 1 unless space[{x,y,z+1}]?
  area += 1 unless space[{x,y,z-1}]?
end

puts area
