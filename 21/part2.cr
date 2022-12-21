#! /usr/bin/crystal
require "../shared.cr"
require "big"

input = File.read("input.txt").strip

alias Operation = Tuple(String, String, Char)
alias BigSym = BigInt | Symbolic
alias Job = Operation | BigSym

monkeys = {} of String => Job

input.lines.each do |line|
  line.match(/(\w+): (.+)$/)
  name = $1
  job = $2
  if num = job.to_i?
    monkeys[name] = BigInt.new(num)
    if name == "humn"
      monkeys[name] = Symbolic.new
    end
  else
    job.match(/(\w+) (.) (\w+)/)
    monkeys[name] = {$1, $3, $2[0]}
    if name == "root"
      monkeys[name] = {$1, $3, '='}
    end
  end
end

class Symbolic
  property operations = [] of Tuple(BigSym, Char)
  
  def +(number)
    operations << {number, '+'}
    self
  end
  
  def -(number)
    operations << {number, '-'}
    self
  end
  
  def *(number)
    operations << {number, '*'}
    self
  end
  
  def //(number)
    operations << {number, '/'}
    self
  end

  def recip(number)
    operations << {number, '^'}
    self
  end

  def evaluate(number : BigInt) : BigInt
    operations.reverse.each do |value, op|
      case op
      when '+'
        number -= value
      when '-'
        number += value
      when '*'
        number //= value
      when '/'
        number *= value
      when '^'
        number = number // value
      end
    end
    return number.as(BigInt)
  end
end

struct BigInt
  def +(num : Symbolic)
    num + self
  end

  def -(num : Symbolic)
    (num * BigInt.new(-1)) + self
  end

  def *(num : Symbolic)
    num * self
  end

  def //(num : Symbolic)
    num.recip self
  end
end

until monkeys["root"].is_a?(BigInt)
  monkeys.each do |name, job|
    if job.is_a?(Operation)
      first = monkeys[job[0]]
      second = monkeys[job[1]]
      if first.is_a?(BigSym) && second.is_a?(BigSym)
        monkeys[name] = case job[2]
                        when '+'
                          first + second
                        when '-'
                          first - second
                        when '*'
                          first * second
                        when '/'
                          if second.is_a?(Symbolic)
                          end
                          first // second
                        when '='
                          if first.is_a?(Symbolic)
                            first.evaluate(second.as(BigInt))
                          elsif second.is_a?(Symbolic)
                            second.evaluate(first.as(BigInt))
                          else
                            BigInt.new(0)
                          end
                        else
                          first // second
                        end
      end
    end
  end
end

puts monkeys["root"]
