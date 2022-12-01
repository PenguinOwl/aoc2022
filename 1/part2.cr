#! /usr/bin/crystal

input = File.read("input.txt").strip

lists = input.split("\n\n")
sums = lists.map do |e|
  e.split("\n").map(&.to_i).sum
end

puts sums.sort.reverse[0..2].sum
