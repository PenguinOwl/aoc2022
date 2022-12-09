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

head = Vector.new
tail = Vector.new

def head_move(head, tail, delta)
  head.move(delta)
  diff = head - tail
  if diff.x.abs <= 1 && diff.y.abs <= 1
    return
  end
  diff.x = diff.x.clamp(-1,1)
  diff.y = diff.y.clamp(-1,1)
  tail.move(diff)
end

dir_right = Vector.new(1,0)
dir_left = Vector.new(-1,0)
dir_up = Vector.new(0,1)
dir_down = Vector.new(0,-1)

record = [] of Tuple(Int32, Int32)

record << tail.position

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
    head_move(head, tail, diff || Vector.new)
    record << tail.position
  end
end

puts record.uniq.size
