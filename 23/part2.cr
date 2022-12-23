#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

alias Vector = Tuple(Int32, Int32)

class Elf
  property proposed : Vector? = nil
end

grid = {} of Vector => Elf
elves = [] of Elf

input.lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    next unless char == '#'
    elf = Elf.new
    grid[{x, y}] = elf
    elves << elf
  end
end

directions = [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]

count = 0

loop do
  count += 1
  # puts directions
  grid.keys.each do |pos|
    elf = grid[pos]
    can_move = false
    (-1..1).each do |x|
      (-1..1).each do |y|
        unless x.zero? && y.zero?
          if grid[{pos[0] + x, pos[1] + y}]?
            can_move = true
          end
        end
      end
    end
    next unless can_move
    directions.each do |direction|
      failed = false
      if direction[0] == 0
        (-1..1).each do |x_offset|
          if grid[{x_offset + pos[0], pos[1] + direction[1]}]?
            failed = true
          end
        end
        next if failed
        elf.proposed = {pos[0], pos[1] + direction[1]}
        break
      elsif direction[1] == 0
        (-1..1).each do |y_offset|
          if grid[{pos[0] + direction[0], y_offset + pos[1]}]?
            failed = true
          end
        end
        next if failed
        elf.proposed = {pos[0] + direction[0], pos[1]}
        break
      end
    end
  end
  possible = elves.select{|e| e.proposed}
  locations = possible.map(&.proposed)
  movers = possible.reject{|e| locations.count(e.proposed) > 1}
  # render(grid)
  if movers.empty?
    break
  end
  movers.each do |elf|
    pos = grid.key_for(elf)
    grid.delete(pos)
    grid[elf.proposed.not_nil!] = elf
  end
  elves.each{|e| e.proposed = nil}
  directions.rotate!
  # render(grid)
end

def render(grid)
  min_x = grid.keys.map(&.[0]).min
  max_x = grid.keys.map(&.[0]).max
  min_y = grid.keys.map(&.[1]).min
  max_y = grid.keys.map(&.[1]).max

  min_y.upto(max_y) do |y|
    min_x.upto(max_x) do |x|
      if elf = grid[{x, y}]?
        print '#'
      else
        print '.'
      end
      print ' '
    end
    print '\n'
  end
end

puts count
