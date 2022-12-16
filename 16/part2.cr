#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Valve
  property name : String
  property flow_rate : Int32
  property tunnels = [] of Valve

  def initialize(@name, @flow_rate)
  end

  def clone
    self
  end
end

class State
  property score = 0
  property time = 26
  property valves_opened = [] of Valve
  property current_valve : Valve
  property elephant_valve : Valve
  property log = [] of String

  def_clone

  def initialize(@current_valve)
    @elephant_valve = @current_valve
  end

  def step
    if time > 0
      log << "(#{valves_opened.map(&.flow_rate).sum} pressure released)"
      you_possibilities = [] of State
      unless valves_opened.includes?(current_valve) || current_valve.flow_rate == 0
        open_valve = self.clone
        open_valve.valves_opened << current_valve
        open_valve.time -= 1
        open_valve.score += open_valve.time * current_valve.flow_rate
        open_valve.log << "opened #{current_valve.name} releasing #{current_valve.flow_rate}"
        you_possibilities << open_valve
      end
      current_valve.tunnels.each do |next_valve|
        take_tunnel = self.clone
        take_tunnel.current_valve = next_valve
        take_tunnel.time -= 1
        take_tunnel.log << "took the tunnel to #{next_valve.name}"
        you_possibilities << take_tunnel
      end
      both_possibilities = [] of State
      you_possibilities.each do |your_move|
        unless your_move.valves_opened.includes?(elephant_valve) || elephant_valve.flow_rate == 0
          open_valve = your_move.clone
          open_valve.valves_opened << elephant_valve
          open_valve.score += open_valve.time * elephant_valve.flow_rate
          open_valve.log << "elephant opened #{elephant_valve.name} releasing #{elephant_valve.flow_rate}"
          both_possibilities << open_valve
        end
        elephant_valve.tunnels.each do |next_valve|
          take_tunnel = your_move.clone
          take_tunnel.elephant_valve = next_valve
          take_tunnel.log << "elephant took the tunnel to #{next_valve.name}"
          both_possibilities << take_tunnel
        end
      end
      log.pop
      both_possibilities
    else
      [self]
    end
  end

  def future_score(depth)
    states = [self]
    depth.times do
      states = states.flat_map(&.step)
    end
    states.max_by(&.score).score
  end

end

valves = [] of Valve

data = input.lines.map do |line|
  line.match(/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.+)/).not_nil!
end

data.each do |match|
  valves << Valve.new(match[1], match[2].to_i)
end

data.each do |match|
  valve = valves.find!{|e| e.name == match[1]}
  tunnel_names = match[3].split(", ")
  valve.tunnels = valves.select{|e| tunnel_names.includes?(e.name)}
end

states = State.new(valves.find!{|e| e.name == "AA"}).step

# puts "starting sim"

26.times do |i|
  # puts "generation #{i + 1}"
  states.sort_by!(&.future_score(3))
  states = states.reverse.first(1000)
  states = states.flat_map(&.step)
end

best = states.max_by(&.score)
# puts best.log.join("\n")
# puts "score: #{best.score}"
puts best.score
