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

SIZE = 50

sides = grid.keys.select{|e| e[0] % SIZE == 0 && e[1] % SIZE == 0}.map{|e| {e[0] // SIZE, e[1] // SIZE}}

side_map = {} of Tuple(Vector, Int32) => Tuple(Vector, Int32)

diff_map = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

side_data = <<-HERE
1,0,l r 0,2,r
1,0,u n 0,3,r
2,0,u n 0,3,u
2,0,r r 1,2,l
2,0,d n 1,1,l
1,1,l n 0,2,d
1,2,d n 0,3,l
0,2,l r 1,0,r
0,3,l n 1,0,d
0,3,d n 2,0,d
1,2,r r 2,0,l
1,1,r n 2,0,u
0,2,u n 1,1,r
0,3,r n 1,2,u
HERE

convert_char = {
  'r' => 0,
  'd' => 1,
  'l' => 2,
  'u' => 3
  }

side_data.lines.each do |line|
  line.match(/(\d+),(\d+),([lurd]) ([rn]) (\d+),(\d+),([lurd])/)
  start_x = $1.to_i
  start_y = $2.to_i
  start_facing = $3[0]
  end_x = $5.to_i
  end_y = $6.to_i
  end_facing = $7[0]
  start_range = [] of Vector
  end_range = [] of Vector
  SIZE.times do |offset|
    case start_facing
    when 'l'
      start_range << {start_x * SIZE, start_y * SIZE + offset}
    when 'r'
      start_range << {start_x * SIZE + SIZE - 1, start_y * SIZE + offset}
    when 'u'
      start_range << {start_x * SIZE + offset, start_y * SIZE}
    when 'd'
      start_range << {start_x * SIZE + offset, start_y * SIZE + SIZE - 1}
    end
    case end_facing
    when 'r'
      end_range << {end_x * SIZE, end_y * SIZE + offset}
    when 'l'
      end_range << {end_x * SIZE + SIZE - 1, end_y * SIZE + offset}
    when 'd'
      end_range << {end_x * SIZE + offset, end_y * SIZE}
    when 'u'
      end_range << {end_x * SIZE + offset, end_y * SIZE + SIZE - 1}
    end
  end
  if $4 == "r"
    end_range.reverse!
  end
  start_range.each_with_index do |start, i|
    side_map[{start,convert_char[start_facing]}] = {end_range[i], convert_char[end_facing]}
  end
end

# puts side_map

x, y = grid.keys
  .select{|e| e[1] == 0}
  .min_by{|e| e[0]}

facing = 0

VIEW = 20

instructions.each do |instruction|
  log = [] of String
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
        rollover, new_facing = side_map[{ {x,y},facing }]
        log << "took rollover #{{ {x,y},facing }} => #{side_map[{ {x,y},facing }]}"
        if grid[rollover].air?
          x, y = rollover.not_nil!
          facing = new_facing
        end
      end
    end
  end
  next
  (y-VIEW).upto(y+VIEW) do |view_y|
    (x-VIEW*2).upto(x+VIEW*2) do |view_x|
      if view_x == x && view_y == y
        print(['>', 'V', '<', '^'][facing])
        next 
      end
      if mat = grid[{view_x, view_y}]?
        if mat.air?
          print '.'
        else
          print '#'
        end
      else
        print ' '
      end
    end
    print '\n'
  end
  print "| coords in chunk: #{{x % SIZE, y % SIZE}} | chunk coords: #{{x // SIZE, y // SIZE}} | facing: #{facing} | #{log.join(", ")} "
  gets
end

puts (1000 * (y + 1)) + (4 * (x + 1)) + facing
