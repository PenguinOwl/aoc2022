#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

pairs = input.split('\n').map do |pair|
  pair.split(',').map do |assignment|
    numbs = assignment.split('-')
    assignment_start = numbs[0].to_i
    assignment_end   = numbs[1].to_i
    assert assignment_end - assignment_start >= 0
    (assignment_start..assignment_end).to_a
  end
end

duplicates = 0

pairs.each do |pair|
  unless (pair[0] & pair[1]).empty?
    duplicates += 1
  end
end

pp duplicates
