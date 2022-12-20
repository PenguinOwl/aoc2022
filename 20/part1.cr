#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Element
  property value : Int32
  def initialize(@value)
  end
end

numbers = input.lines.map{|e| Element.new(e.to_i)}

final = numbers.dup

# puts final.map(&.value)

numbers.each do |element|
  index = final.index!(element)
  final.delete_at(index)
  new_index = index + element.value
  new_index %= final.size
  if new_index == 0
    new_index += final.size
  end
  # offset = (element.value % final.size != element.value) ? -1 : 0
  # new_index += offset
  final.insert(new_index, element)
  # puts "#{element.value} moves between #{final[(new_index-1)% final.size].value} and #{final[(new_index+1)% final.size].value}"
  # puts final.map(&.value)
end

zero_index = final.index!(&.value.zero?)

puts [1000, 2000, 3000].map{|i| final[(zero_index + i) % final.size].value}.sum
