#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

lists = input.split("\n\n")
sums = lists.map do |e|
  val = e.split("\n").map(&.to_i).sum
  assert val > 0
  val
end

puts sums.max
