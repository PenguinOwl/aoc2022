#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

chars = input.chars

char_buffer = [] of Char

chars.each_with_index do |char, i|
  char_buffer << char
  if char_buffer.size > 4
    char_buffer.shift
  end
  if (char_buffer).uniq.size == 4
    pp i + 1
    break
  end
end
