#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Node
  property outers = [] of Node
  property height = 0
  property distance = Int32::MAX
  property heuristic = 0.0

  def initialize(@height, @heuristic)
  end

  def Node.traverse(startpoint, endpoint)
    nodes = [startpoint]
    until nodes.empty?
      best = nodes.find!{|node| node.distance + 1.5 * node.heuristic}
      nodes.delete(best)
      if best == endpoint
        break
      end
      current_distance = best.distance
      best.outers.each do |outer|
        if outer.distance > best.distance + 1
          outer.distance = best.distance + 1
          nodes << outer
        end
      end
    end
  end
end

start_marker = {0, 0}
end_marker = {0, 0}

grid = input.lines.map(&.chars)

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == 'S'
      start_marker = {x, y}
    elsif char == 'E'
      end_marker = {x, y}
    end
  end
end

node_grid = grid.map_with_index do |line, y|
  line.map_with_index do |char, x|
    elevation = 0
    if char == 'S'
      elevation = 0
    elsif char == 'E'
      elevation = 25
    else
      elevation = char.ord - 'a'.ord
    end
    heuristic = Math.sqrt((x - end_marker[0])**2 + (y - end_marker[0])**2)
    Node.new(elevation, heuristic)
  end
end

node_grid.each_with_index do |row, y|
  row.each_with_index do |node, x|
    outer_list = node.outers
    if y > 0
      outer_list << node_grid[y-1][x]
    end
    if y < node_grid.size - 1
      outer_list << node_grid[y+1][x]
    end
    if x > 0
      outer_list << node_grid[y][x-1]
    end
    if x < row.size - 1
      outer_list << node_grid[y][x+1]
    end
    outer_list.reject!{|outer| outer.height > (node.height + 1) }
  end
end

start_node = node_grid[start_marker[1]][start_marker[0]]
end_node = node_grid[end_marker[1]][end_marker[0]]

start_node.distance = 0

Node.traverse(start_node, end_node)

puts end_node.distance
