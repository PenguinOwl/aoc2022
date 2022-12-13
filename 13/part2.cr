#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

alias Element = Int32 | Array(Element)

def decode_element(string) : Element
  if string[0] == '['
    depth = -1
    array = [] of String
    current = [] of Char
    string.chars.each do |char|
      if char == '['
        if depth >= 0
          current << char
        end
        depth += 1
      elsif char == ']'
        if depth >= 1
          current << char
        end
        depth -= 1
      elsif char == ',' && depth == 0
        array << current.join
        current.clear
      else
        current << char
      end
    end
    unless current.empty?
      array << current.join
    end
    return array.map{|e| decode_element(e) }.as(Element)
  else
    return string.to_i.as(Element)
  end
end

pairs = input.split("\n\n").map do |pair|
  pair.split('\n').map do |line|
    decode_element(line)
  end
end

enum State
  PASS
  FAIL
  UNDECIDED
end

def compare(first : Element, second : Element) : State
  case {first, second}
  when {Int32, Int32}
    case first <=> second
    when 0
      return State::UNDECIDED
    when 1
      return State::FAIL
    when -1
      return State::PASS
    end
  when {Array(Element), Int32}
    return compare(first, [second.as(Element)])
  when {Int32, Array(Element)}
    return compare([first.as(Element)], second)
  when {Array(Element), Array(Element)}
    max_index = Math.min(first.size, second.size) - 1
    unless max_index == - 1
      (0..max_index).each do |i|
        result = compare(first[i], second[i])
        unless result.undecided?
          return result
        end
      end
    end
    case first.size <=> second.size
    when -1
      return State::PASS
    when 1
      return State::FAIL
    else
      return State::UNDECIDED
    end
  end
  return State::UNDECIDED
end  

packets = pairs.flat_map(&.itself)

divider1 = decode_element("[[2]]")
divider2 = decode_element("[[6]]")

packets << divider1
packets << divider2

packets.sort! do |a, b|
  case compare(a, b)
  when .pass?
    -1
  when .fail?
    1
  else
    0
  end
end

decoder_key = 1

decoder_key *= packets.index!(divider1) + 1
decoder_key *= packets.index!(divider2) + 1

puts decoder_key
