#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Tree
  property height : Int32
  property visible = false
  property score = 1

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
  treeline = [] of Int32
  row.each do |tree|
    seen = treeline.index{|height| height >= tree.height}
    if seen
      score_modifier = seen + 1
    else
      score_modifier = treeline.size
    end
    treeline.unshift(tree.height)
    tree.score *= score_modifier
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

puts grid.flatten.max_by{|tree| tree.score}.score
