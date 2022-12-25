#! /usr/bin/crystal
require "../shared.cr"

input = File.read("input.txt").strip

def parse_snafu(string)
  value = 0_i64
  string.chars.reverse.each_with_index do |char, place|
    digit = case char
            when '2'
              2
            when '1'
              1
            when '0'
              0
            when '-'
              -1
            when '='
              -2
            else
              0
            end
    value += 5_i64**place * digit
  end
  value
end

CHAR_MAP = {
  -2 => '=',
  -1 => '-',
  0 => '0',
  1 => '1',
  2 => '2'
}

def to_snafu(int)
  if int == 0
    max_digit = 0
  else
    max_digit = Math.log(int, 5).to_i
  end
  places = Array(Int64).new(max_digit + 1, 0)
  value = int
  0.upto(max_digit) do |place|
    places[place] = value % 5
    value //= 5
  end
  places.each_with_index do |place, i|
    while place > 2
      if places[i+1]?
        places[i+1] += 1
      else
        places << 1
      end
      places[i] -= 5
      place -= 5
    end
  end
  places.map{|e| CHAR_MAP[e]}.reverse.join
end

tests = <<-HERE
        1
        2
        3
        4
        5
        6
        7
        8
        9
       10
       15
       20
     2022
    12345
314159265
HERE

# tests.split('\n').map do |num|
#   puts to_snafu(num.strip.to_i)
# end

puts to_snafu(input.lines.map{|e| parse_snafu(e)}.sum)
