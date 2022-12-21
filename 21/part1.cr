#! /usr/bin/crystal
require "../shared.cr"
require "big"

input = File.read("input.txt").strip

alias Operation = Tuple(String, String, Char)
alias Job = Operation | BigInt

monkeys = {} of String => Job

input.lines.each do |line|
  line.match(/(\w+): (.+)$/)
  name = $1
  job = $2
  if num = job.to_i?
    monkeys[name] = BigInt.new(num)
  else
    job.match(/(\w+) (.) (\w+)/)
    monkeys[name] = {$1, $3, $2[0]}
  end
end

until monkeys["root"].is_a?(BigInt)
  monkeys.each do |name, job|
    if job.is_a?(Operation)
      first = monkeys[job[0]]
      second = monkeys[job[1]]
      if first.is_a?(BigInt) && second.is_a?(BigInt)
        monkeys[name] = case job[2]
                        when '+'
                          first + second
                        when '-'
                          first - second
                        when '*'
                          first * second
                        when '/'
                          first // second
                        else
                          first // second
                        end
      end
    end
  end
end

puts monkeys["root"]
