#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt")

sections = input.split("\n\n")

initial_crates = sections[0].split("\n")[0..-2].map do |row|
  row.chars.map_with_index{|e, i| ((i-1) % 4 == 0) ? e : nil}.compact
end

crates = initial_crates.reverse.transpose
crates.each(&.delete(' '))

instructions = sections[1].split('\n')

instructions.each do |instruction|
  if /move (\d+) from (\d+) to (\d+)/.match(instruction)
    number = $1.to_i
    from_stack = $2.to_i - 1
    to_stack = $3.to_i - 1
    number.times do
      crates[to_stack].push(crates[from_stack].pop)
    end
  end
end

puts crates.map{|e| e[-1]}.join
