#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip


class Vector
  property x = 0
  property y = 0

  def initialize(@x = 0, @y = 0)
  end

  def position
    {@x, @y}
  end

  def position=(tuple)
    x = tuple[0]
    y = tuple[1]
  end

  def +(vector)
    Vector.new(@x + vector.x, @y + vector.y)
  end

  def -(vector)
    Vector.new(@x - vector.x, @y - vector.y)
  end

  def *(int)
    Vector.new(@x * int, @y * int)
  end

  def move(vector)
    @x += vector.x
    @y += vector.y
  end
end

nodes = Array.new(10){ Vector.new }

def update_pair(head, tail)
  diff = head - tail
  if diff.x.abs <= 1 && diff.y.abs <= 1
    return
  end
  diff.x = diff.x.clamp(-1,1)
  diff.y = diff.y.clamp(-1,1)
  tail.move(diff)
end

def move_trail(nodes, delta)
  nodes[0].move(delta)
  last_pair = nodes.size - 2
  (0..last_pair).each do |index|
    update_pair(nodes[index], nodes[index+1])
  end
end

dir_right = Vector.new(1,0)
dir_left = Vector.new(-1,0)
dir_up = Vector.new(0,1)
dir_down = Vector.new(0,-1)

record = [] of Tuple(Int32, Int32)

record << Vector.new.position

input.lines.each do |line|
  values = line.split(' ')
  assert values.size == 2
  direction = values[0]
  distance = values[1].to_i
  diff = case direction
         when "R"; dir_right
         when "L"; dir_left
         when "U"; dir_up
         when "D"; dir_down
         end
  distance.times do
    assert diff
    move_trail(nodes, diff || Vector.new)
    record << nodes[-1].position
  end
end

puts record.uniq.size
