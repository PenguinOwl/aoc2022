#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

lines = input.lines.map do |line|
  line.split(" -> ").map do |coord_pair|
    coord_pair.split(",").map(&.to_i)
  end
end

enum Material
  ROCK
  SAND
end

grid = {} of Tuple(Int32, Int32) => Material

lines.each do |shape|
  last_vertex = nil
  shape.each do |vertex|
    if last_vertex
      if last_vertex[0] < vertex[0]
        y = last_vertex[1]
        (last_vertex[0]..vertex[0]).each do |x|
          grid[{x,y}] = Material::ROCK
        end
      elsif last_vertex[1] < vertex[1]
        x = last_vertex[0]
        (last_vertex[1]..vertex[1]).each do |y|
          grid[{x,y}] = Material::ROCK
        end
      elsif last_vertex[0] > vertex[0]
        y = last_vertex[1]
        (vertex[0]..last_vertex[0]).each do |x|
          grid[{x,y}] = Material::ROCK
        end
      elsif last_vertex[1] > vertex[1]
        x = last_vertex[0]
        (vertex[1]..last_vertex[1]).each do |y|
          grid[{x,y}] = Material::ROCK
        end
      end
    end
    last_vertex = vertex
  end
end


max = lines.flat_map(&.itself).map{|e| e[1]}.max

(-10000).upto(10000).each do |x|
  grid[{x, max + 2}] = Material::ROCK
end

def drop_sand(grid, max)
  x = 500
  y = 0
  if grid[{x,y}]?
    return false
  end
  until y > max + 5
    if !grid[{x,y+1}]?
      y += 1
    elsif !grid[{x-1,y+1}]?
      x -= 1
      y += 1
    elsif !grid[{x+1,y+1}]?
      x += 1
      y += 1
    else
      grid[{x,y}] = Material::SAND
      return true
    end
  end
  return false
end

sand_dropped = 0

loop do
  break unless drop_sand(grid, max)
  sand_dropped += 1
end

puts sand_dropped
