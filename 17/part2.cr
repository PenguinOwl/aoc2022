#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Rock
  property solids = [] of Tuple(Int64, Int64)
  property width = 0_i64
  property height = 0_i64
  property x = 0_i64
  property y = 0_i64

  def initialize(@solids)
    solid_x = solids.map{|e| e[0]}
    solid_y = solids.map{|e| e[1]}
    @width = solid_x.max - solid_x.min + 1
    @height = solid_y.max - solid_y.min + 1
  end

  def self.generate(string)
    solids = [] of Tuple(Int64, Int64)
    string.lines.reverse.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if char == '#'
          solids << {x.to_i64, y.to_i64}
        end
      end
    end
    new(solids)
  end

  def occupied
    return solids.map{ |e| {e[0] + x, e[1] + y} }
  end

  def left
    @x
  end

  def left=(val)
    @x = val
  end

  def right
    @x + @width - 1
  end

  def right=(val)
    @x = val - @width + 1
  end

  def top
    @y + @height - 1
  end

  def top=(val)
    @y = val - @height + 1
  end

  def bottom
    @y
  end

  def bottom=(val)
    @y = val
  end

end

rock_data = <<-HERE
####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##
HERE

rocks = rock_data.split("\n\n").map{|e| Rock.generate(e)}

right_jets = input.chars.map{|e| e == '>'}

jet_index = 0
rock_index = 0

grid : Array(Tuple(Int64, Int64)) = [{0i64, 0i64}]

cache = {} of UInt64 => Array(Tuple(Int64, Int64, Int64))

count : Int64 = 0

SIMS = 1000000000000

jumped = false

until count == SIMS
  rock = rocks[rock_index].dup
  rock_index += 1
  rock_index %= rocks.size
  rock.bottom = grid.map{|e| e[1]}.max + 4
  rock.left = 2
  loop do
    old_x = rock.x
    if right_jets[jet_index]
      rock.x += 1
    else
      rock.x -= 1
    end
    jet_index += 1
    jet_index %= right_jets.size
    if rock.right > 6 || rock.left < 0 || !(grid & rock.occupied).empty?
      rock.x = old_x
    end
    rock.y -= 1
    if !(grid & rock.occupied).empty? || rock.bottom <= 0
      rock.y += 1
      grid.concat(rock.occupied)
      break
    end
    top = grid.map{|e| e[1]}.max
    grid.select!{|e| e[1] > top - 50}
  end
  top = grid.map{|e| e[1]}.max
  unless jumped
    hash = {rock_index, jet_index}.hash
    if old_data = cache[hash]?
      difference = top - old_data.last[0]
      if repeat = old_data.find{|e| e[2] == difference}
        jumped = true
        cycle_length = count - repeat[1]
        cycle_height = top - repeat[0]
        skipped_cycles = (SIMS - count) // cycle_length
        skipped_rocks = skipped_cycles * cycle_length
        grid.map!{|e| {e[0], e[1] + cycle_height * skipped_cycles}}
        count += skipped_rocks
      end
      cache[hash] << {top, count, difference}
    else
      cache[hash] = [{top, count, 0i64}]
    end
  end
  count += 1
  puts count
end

puts grid.map{|e| e[1]}.max
