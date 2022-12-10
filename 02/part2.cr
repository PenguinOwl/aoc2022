#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

d_enemy = { 'A' => 1, 'B' => 2, 'C' => 3 }
d_you   = { 'X' => 1, 'Y' => 2, 'Z' => 3 }

vals = input.split("\n").map do |string|
  enemy = d_enemy[string[0]]
  result = d_you[string[2]]
  you = case {enemy, result}
  when {1,1} ; 3
  when {2,1} ; 1
  when {3,1} ; 2
  when {1,2} ; 1
  when {2,2} ; 2
  when {3,2} ; 3
  when {1,3} ; 2
  when {2,3} ; 3
  when {3,3} ; 1
  end
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
  bonus + you.not_nil!
end

puts vals.sum
