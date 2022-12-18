#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

cubes = input.lines.map(&.split(",").map(&.to_i))

space = {} of Tuple(Int32, Int32, Int32) => Bool

area = 0

cubes.each do |cube|
  space[{cube[0], cube[1], cube[2]}] = true
end

x_max = space.keys.map{|e| e[0]}.max + 1
x_min = space.keys.map{|e| e[0]}.min - 1
y_max = space.keys.map{|e| e[1]}.max + 1
y_min = space.keys.map{|e| e[1]}.min - 1
z_max = space.keys.map{|e| e[2]}.max + 1
z_min = space.keys.map{|e| e[2]}.min - 1

coord_list = [{x_max, y_max, z_max}]

until coord_list.empty?
  fill_point = coord_list[0]
  x = fill_point[0]
  y = fill_point[1]
  z = fill_point[2]
  coord_list.delete(fill_point)
  diffs = [{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}]
  diffs.each do |diff|
    coord = {
      (x + diff[0]).clamp(x_min,x_max),
      (y + diff[1]).clamp(y_min,y_max),
      (z + diff[2]).clamp(z_min,z_max)
    }
    unless space.has_key?(coord)
      coord_list << coord
      space[coord] = false
    end
  end
end

(x_min..x_max).each do |x|
  (y_min..y_max).each do |y|
    (z_min..z_max).each do |z|
      unless space.has_key?({x,y,z})
        space[{x,y,z}] = true
      end
    end
  end
end

space.each do |coord, exists|
  if exists
    x = coord[0]
    y = coord[1]
    z = coord[2]
    area += 1 unless space[{x+1,y,z}]?
    area += 1 unless space[{x-1,y,z}]?
    area += 1 unless space[{x,y+1,z}]?
    area += 1 unless space[{x,y-1,z}]?
    area += 1 unless space[{x,y,z+1}]?
    area += 1 unless space[{x,y,z-1}]?
  end
end

puts area
