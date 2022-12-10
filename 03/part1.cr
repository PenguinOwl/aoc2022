#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

rucksacks = input.split("\n").map do |string|
  list = string.chars
  length = list.size
  assert list.size.even?
  [list[0..(length//2-1)], list[length//2..-1]]
end

total = 0

rucksacks.each do |rucksack|
  same = rucksack[0] & rucksack[1]
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

