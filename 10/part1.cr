#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class CPU
  property x = 1
  property cycle = 1
  property instructions = [] of Instruction

  class Instruction
    property cycles_remaining : Int32
    property block : Proc(Void)

    def initialize(@cycles_remaining, &block)
      @block = block
    end
  end

  def read_instruction(line)
    values = line.split(' ')
    command = values[0]
    args = values[1..-1]? || [] of String
    assert command.size > 1
    instruction = case command
    when "noop"
      Instruction.new(1) {}
    when "addx"
      Instruction.new(2) do
        @x += args[0].to_i
      end
    end
    if instruction
      @instructions << instruction
    end
  end

  def process
    @cycle += 1
    if current = @instructions.first?
      current.cycles_remaining -= 1
      if current.cycles_remaining <= 0
        current.block.call
        @instructions.delete_at(0)
      end
    end
  end
end

cpu = CPU.new

input.lines.each do |line|
  cpu.read_instruction(line)
end

check_on = [20, 60, 100, 140, 180, 220]

signal_strength = 0

until cpu.instructions.empty?
  cpu.process
  if check_on.includes?(cpu.cycle)
    signal_strength += cpu.cycle * cpu.x
  end
end

puts signal_strength
