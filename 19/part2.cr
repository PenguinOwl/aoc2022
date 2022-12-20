#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

struct Blueprint
  property ore_ore_cost : Int32
  property clay_ore_cost : Int32
  property obby_ore_cost : Int32
  property obby_clay_cost : Int32
  property geode_ore_cost : Int32
  property geode_obby_cost : Int32

  def initialize(
    @ore_ore_cost,
    @clay_ore_cost,
    @obby_ore_cost,
    @obby_clay_cost,
    @geode_ore_cost,
    @geode_obby_cost
  )
  end
end

class State
  property children = [] of State
  property evaluated = false
  property blueprint : Blueprint
  property time = 32
  property ore = 0
  property ore_robots = 1
  property clay = 0
  property clay_robots = 0
  property obby = 0
  property obby_robots = 0
  property geode = 0
  property geode_robots = 0
  # property log = [] of String

  def score
    ore + clay * 100 + obby * 10000 + geode * 1000000
  end

  def dup
    new_state = State.new(blueprint)
    new_state.time = time
    new_state.ore = ore
    new_state.ore_robots = ore_robots
    new_state.clay = clay
    new_state.clay_robots = clay_robots
    new_state.obby = obby
    new_state.obby_robots = obby_robots
    new_state.geode = geode
    new_state.geode_robots = geode_robots
    # new_state.log = log.dup
    return new_state
  end

  def initialize(@blueprint)
  end

  def produce
    @time -= 1
    @ore += @ore_robots
    if ore_robots > 0
      # log << "ore robots produced #{ore_robots}, at #{ore} ore"
    end
    @clay += @clay_robots
    if clay_robots > 0
      # log << "clay robots produced #{clay_robots}, at #{clay} clay"
    end
    @obby += @obby_robots
    if obby_robots > 0
      # log << "obby robots produced #{obby_robots}, at #{obby} obby"
    end
    @geode += @geode_robots
    if geode_robots > 0
      # log << "geode robots produced #{geode_robots}, at #{geode} geode"
    end
  end

  def step
    return @children if evaluated
    # log << ""
    if time > 0
      # option: do nothing
      do_nothing = dup
      # do_nothing.log << "did nothing"
      do_nothing.produce
      @children << do_nothing

      # option: build ore robot
      if ore >= blueprint.ore_ore_cost
        build_ore = dup
        build_ore.ore -= blueprint.ore_ore_cost
        # build_ore.log << "built an ore robot"
        build_ore.produce
        build_ore.ore_robots += 1
        children << build_ore
      end

      # option: build clay robot
      if ore >= blueprint.clay_ore_cost
        build_clay = dup
        build_clay.ore -= blueprint.clay_ore_cost
        # build_clay.log << "built an clay robot"
        build_clay.produce
        build_clay.clay_robots += 1
        children << build_clay
      end

      # option: build obby robot
      if ore >= blueprint.obby_ore_cost && clay >= blueprint.obby_clay_cost
        build_obby = dup
        build_obby.ore -= blueprint.obby_ore_cost
        build_obby.clay -= blueprint.obby_clay_cost
        # build_obby.log << "built an obby robot"
        build_obby.produce
        build_obby.obby_robots += 1
        children << build_obby
      end

      # option: build geode robot
      if ore >= blueprint.geode_ore_cost && obby >= blueprint.geode_obby_cost
        build_geode = dup
        build_geode.ore -= blueprint.geode_ore_cost
        build_geode.obby -= blueprint.geode_obby_cost
        # build_geode.log << "built a geode robot"
        build_geode.produce
        build_geode.geode_robots += 1
        children << build_geode
      end
    else
      @children = [self]
    end
    @evaluated = true
    return @children
  end

  def future_score(depth)
    states = [self]
    depth.times do
      states = states.flat_map(&.step)
    end
    states.max_by(&.score).score
  end
end

blueprints = [] of Blueprint

input.lines.each do |line|
  line.match(/Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./)
  blueprints << Blueprint.new(*({$2, $3, $4, $5, $6, $7}.map(&.to_i)))
end

blueprints = blueprints[0..2]

qualities = blueprints.map_with_index do |blueprint, i|
  # puts "started #{i}"
  states = [State.new(blueprint)]
  32.times do
    states = states
      .flat_map(&.step)
      .sort_by(&.future_score(4))
      .last(1000)
  end
  # puts states.max_by(&.geode).log.join("\n")
  states.map(&.geode).max
end

puts qualities.product
