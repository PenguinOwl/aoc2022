#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt")

alias Vector = Tuple(Int32, Int32)

enum Material
  AIR
  WALL
end

grid = {} of Vector => Material
instructions = [] of Int32 | Char

sections = input.split("\n\n")

sections[0].lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    case char
    when '.'
      grid[{x, y}] = Material::AIR
    when '#'
      grid[{x, y}] = Material::WALL
    end
  end
end

sections[1].scan(/[LR]|[0-9]+/) do |data|
  if num = data[0].to_i?
    instructions << num
  else
    instructions << data[0][0]
  end
end

x, y = grid.keys
  .select{|e| e[1] == 0}
  .min_by{|e| e[0]}

facing = 0

diff_map = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

instructions.each do |instruction|
  case instruction
  when Char
    case instruction
    when 'L'
      facing -= 1
    when 'R'
      facing += 1
    end
    facing %= 4
  when Int32
    instruction.times do
      new_pos = {x + diff_map[facing][0], y + diff_map[facing][1]}
      if space = grid[new_pos]?
        if space.air?
          x, y = new_pos
        end
      else
        rollover = case facing
                   when 0
                     grid.keys.select{|e| e[1] == y}.min_by{|e| e[0]}
                   when 1
                     grid.keys.select{|e| e[0] == x}.min_by{|e| e[1]}
                   when 2
                     grid.keys.select{|e| e[1] == y}.max_by{|e| e[0]}
                   when 3
                     grid.keys.select{|e| e[0] == x}.max_by{|e| e[1]}
                   end
        if grid[rollover].air?
          x, y = rollover.not_nil!
        end
      end
    end
  end
end

puts (1000 * (y + 1)) + (4 * (x + 1)) + facing
