#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

alias Vector = Tuple(Int32, Int32)

class Wind
  property direction : Vector
  property x : Int32
  property y : Int32
  property x_min = 0
  property x_max = 0
  property y_min = 0
  property y_max = 0

  def initialize(@direction, @x, @y)
  end

  def position
    {x, y}
  end

  def step
    @x += direction[0]
    @y += direction[1]
  end
end

class Grid
  property x_min = 0
  property x_max = 0
  property y_min = 0
  property y_max = 0
  property winds = [] of Wind
  property steps = [] of Array(Vector)

  def generate_grid
    grid = [] of Vector
    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        unless winds.find{|wind| wind.position == {x, y}}
          grid << {x, y}
        end
      end
    end
    steps << grid
  end

  def step
    winds.each do |wind|
      wind.step
      wind.x = ((wind.x - x_min) % (x_max - x_min + 1)) + x_min
      wind.y = ((wind.y - y_min) % (y_max - y_min + 1)) + y_min
    end
    generate_grid
  end

  def [](index)
    until steps[index]?
      # puts "rendering minute #{index + 1}"
      step
    end
    return steps[index]
  end
end

ACTIONS = [{0, 0}, {1, 0}, {-1, 0}, {0, 1}, {0, -1}]

class State
  property time = 0
  property x = 1
  property y = 0
  property children = nil
  property goal : Vector

  def initialize(@goal)
  end

  def success?
    goal == {x, y + 1}
  end

  def dup
    new_state = State.new(goal)
    new_state.time = time
    new_state.x = x
    new_state.y = y
    new_state
  end

  def step(grid) : Array(State)
    return children.not_nil! if children
    @children = [] of State
    spaces = grid[time + 1]
    if {x, y} == {1, 0}
      child = dup
      child.time += 1
      @children.not_nil! << child
    end
    ACTIONS.each do |diff|
      if spaces.includes?({diff[0] + x, diff[1] + y})
        child = dup
        child.x += diff[0]
        child.y += diff[1]
        child.time += 1
        @children.not_nil! << child
      end
    end
    @children.not_nil!
  end

  def score
    # Math.sqrt(time) + Math.sqrt((goal[0] - x)**2 + (goal[1] - y)**2)
    time + Math.sqrt((goal[0] - x)**2 + (goal[1] - y)**2)
    # Math.sqrt((goal[0] - x)**2 + (goal[1] - y)**2)
    # Math.sqrt(time) + (goal[0] - x).abs + (goal[1] - y).abs
  end

  def future_score(depth, grid)
    states = [self]
    depth.times do
      states = states.flat_map(&.step(grid))
    end
    states.min_by(&.score).score
  end
end

grid = Grid.new
grid.x_min = 1
grid.y_min = 1
grid.x_max = input.lines[0].chars.size - 2
grid.y_max = input.lines.size - 2

input.lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    case char
    when '>'
      grid.winds << Wind.new({1, 0}, x, y)
    when 'v'
      grid.winds << Wind.new({0, 1}, x, y)
    when '<'
      grid.winds << Wind.new({-1, 0}, x, y)
    when '^'
      grid.winds << Wind.new({0, -1}, x, y)
    end
  end
end

grid.generate_grid

DIRECTION_MAP = {
  {1, 0} => '>',
  {-1, 0} => '<',
  {0, 1} => 'v',
  {0, -1} => '^'
  }

def render(grid, state)
  # puts "\nminute #{state.time}"
  return
  chars = [] of Char
  grid.y_min.upto(grid.y_max) do |y|
    grid.x_min.upto(grid.x_max) do |x|
      if x == state.x && y == state.y
        chars << 'E'
        next
      end
      blizzards = grid[state.time].count({x, y})
      case blizzards
      when 0
        chars << '·'
      else
        chars << ' '
      end
    end
    chars << '\n'
  end
  chars << '\n'
  puts chars.join
  # gets

end

goal = {grid.x_max, grid.y_max + 1}

states = [State.new(goal)]

initial = State.new(goal)

count = 0

until states.find(&.success?)
  count += 1
  # puts count
  render(grid, states.first)
  # states = states
  #   .flat_map(&.step(grid))
  #   .sort_by(&.future_score(1, grid))
  #   .sort_by(&.score)
  #   .first(4000)
  states = states.uniq{|e| {e.time, e.x, e.y}}.sort_by(&.score)
  # pp states[0..20].map{|state| {score: state.score, time: state.time, pos: {state.x, state.y}}}
  states.concat(states.shift.step(grid))
end

render(grid, states.find!(&.success?))

# puts count
puts states.find!(&.success?).time + 1
