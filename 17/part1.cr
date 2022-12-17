#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Rock
  property solids = [] of Tuple(Int32, Int32)
  property width = 0
  property height = 0
  property x = 0
  property y = 0

  def initialize(@solids)
    solid_x = solids.map{|e| e[0]}
    solid_y = solids.map{|e| e[1]}
    @width = solid_x.max - solid_x.min + 1
    @height = solid_y.max - solid_y.min + 1
  end

  def self.generate(string)
    solids = [] of Tuple(Int32, Int32)
    string.lines.reverse.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        if char == '#'
          solids << {x, y}
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

grid = [{0, 0}]

2022.times do |rock_index|
  rock = rocks[rock_index % rocks.size].dup
  rock.bottom = grid.map{|e| e[1]}.max + 4
  rock.left = 2
  loop do
    old_x = rock.x
    if right_jets[jet_index % right_jets.size]
      rock.x += 1
    else
      rock.x -= 1
    end
    jet_index += 1
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
    grid.select!{|e| e[1] > top - 10}
  end
end

puts grid.map{|e| e[1]}.max
