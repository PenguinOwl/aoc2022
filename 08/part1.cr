#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Tree
  property height : Int32
  property visible = false

  def initialize(@height)
  end
end

grid = input.lines.map do |line|
  line.chars.map do |char|
    Tree.new(char.to_i)
  end
end

def mark_row(row)
  height = -1
  row.each do |tree|
    if tree.height > height
      tree.visible = true
      height = tree.height
    end
  end
end

def mark_visible(grid)
  grid.each do |row|
    mark_row(row)
    mark_row(row.reverse)
  end
end

rows = grid
columns = grid.transpose

mark_visible(rows)
mark_visible(columns)

puts grid.flatten.sum{|tree| tree.visible ? 1 : 0}
