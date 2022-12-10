#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

d_enemy = { 'A' => 1, 'B' => 2, 'C' => 3 }
d_you   = { 'X' => 1, 'Y' => 2, 'Z' => 3 }

vals = input.split("\n").map do |string|
  enemy = d_enemy[string[0]]
  you = d_you[string[2]]
  bonus = 0
  case {enemy, you}
  when {1,2}
    bonus = 6
  when {2,3}
    bonus = 6
  when {3,1}
    bonus = 6
  end
  if enemy == you
    bonus = 3
  end
  bonus + you
end

puts vals.sum
