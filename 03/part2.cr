#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

rucksacks = input.split("\n").map do |string|
  list = string.chars
  length = list.size
  assert list.size.even?
  list || [] of Char
end

total = 0

rucksacks.in_groups_of(3).each do |group|
  group = group.compact
  same = group[0] & group[1] & group[2]
  assert same.size == 1
  if char = same[0]?
    assert char.letter?
    value = char.downcase - 'a' + 1
    if char.uppercase?
      value += 26
    end
    assert value <= 52
    assert value > 0
    total += value
  end
end

pp total

