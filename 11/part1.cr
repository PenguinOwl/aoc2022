#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

class Item
  property worry_level = 0

  def initialize(@worry_level)
  end
end

class Monkey
  property index : Int32
  property items = [] of Item
  property inspections = 0
  getter operation = Proc(Int32, Int32).new {0}
  getter test = Proc(Item, Void).new {}

  def initialize(@index)
  end

  def register_operation(&block : Int32 -> Int32)
    @operation = block
  end

  def register_test(&block : Item -> Nil)
    @test = block
  end

  def activate
    while items.size > 0
      @inspections += 1
      item = items.shift
      item.worry_level = @operation.call(item.worry_level) // 3
      @test.call(item)
    end
  end
end

monkeys = [] of Monkey

input.split("\n\n").each do |monkey_text|
  lines = monkey_text.lines
  monkey_index = lines[0].match(/Monkey (\d+):/).not_nil![1].to_i
  item_list = lines[1].match(/Starting items: (.+)$/).not_nil![1]
  items = item_list.split(", ").map(&.to_i)
  function_data = lines[2].match(/Operation: new = old (\*|\+) (\d+|old)/).not_nil!
  operand = function_data[1]
  argument = 0
  double_old = function_data[2] == "old"
  unless double_old
    argument = function_data[2].to_i
  end

  modulo = lines[3].match(/Test: divisible by (\d+)/).not_nil![1].to_i
  true_target = lines[4].match(/f true: throw to monkey (\d+)/).not_nil![1].to_i
  false_target = lines[5].match(/f false: throw to monkey (\d+)/).not_nil![1].to_i

  monkey = Monkey.new(monkey_index)
  monkey.items = items.map{|e| Item.new(e)}
  monkey.register_operation do |original|
    case {operand, double_old}
    when {"+", true}
      original + original
    when {"+", false}
      original + argument
    when {"*", true}
      original * original
    when {"*", false}
      original * argument
    else
      0
    end
  end
  monkey.register_test do |item|
    target_index = 0
    if (item.worry_level % modulo) == 0
      target_index = true_target
    else
      target_index = false_target
    end
    monkeys.find!{|e| e.index == target_index}.items.push(item)
  end
  monkeys << monkey
end

monkeys.sort_by!{|e| e.index}

20.times do
  monkeys.each do |monkey|
    monkey.activate
  end
end

puts monkeys.map(&.inspections).sort.reverse.first(2).product
