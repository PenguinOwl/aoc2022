#! /usr/bin/crystal
require "../shared.cr"
require "big"

input = File.read("input.txt").strip

class Sensor
  property x = 0
  property y = 0
  property radius = 0

  def initialize(@x, @y, @radius)
  end
end

sensors = input.lines.map do |line|
  line.match(/Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/)
  Sensor.new($1.to_i, $2.to_i, ($1.to_i - $3.to_i).abs + ($2.to_i - $4.to_i).abs)
end

ranges = [] of Tuple(Int32, Int32)

def merge_ranges(array)
  merged_ranges = [] of Tuple(Int32, Int32)
  current_range = 0
  depth = 0
  starts = array.map{|e| e[0]}.sort
  ends = array.map{|e| e[1]}.sort
  until ends.empty?
    if !starts.empty? && starts.first < ends.first
      value = starts.shift
      if depth == 0
        current_range = value
      end
      depth += 1
    else
      value = ends.shift
      depth -= 1
      if depth == 0
        merged_ranges << {current_range, value}
      end
    end
  end
  merged_ranges
end

sensors.each do |sensor|
  right = sensor.x + sensor.radius - sensor.y + 1
  left = sensor.x - sensor.radius - sensor.y - 1
  ranges << {left, right}
  print({left, right}, '\n')
end

starts = ranges.map{|e| e[0]}
diff_vals = ranges.select{|e| starts.includes?(e[1])}.map{|e| e[1]}.uniq

ranges.clear

sensors.each do |sensor|
  right = sensor.x + sensor.radius + sensor.y + 1
  left = sensor.x - sensor.radius + sensor.y - 1
  ranges << {left, right}
  print({left, right}, '\n')
end

starts = ranges.map{|e| e[0]}
sum_vals = ranges.select{|e| starts.includes?(e[1])}.map{|e| e[1]}.uniq

y = (sum_vals[0] - diff_vals[0]) // 2
x = sum_vals[0] - y

puts BigInt.new(x)*4000000 + y
