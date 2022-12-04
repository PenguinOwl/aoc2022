require "colorize"

module Assertions
  @@assertion_hashes = [] of UInt64
  @@counts = [] of UInt64

  def self.hashes
    @@assertion_hashes
  end

  def self.counts
    @@counts
  end
end

macro assert(code)
  hash = {{code.stringify}}.hash
  file_loc = "{{code.filename.gsub(/^.+\//,"").id}}:{{code.line_number}} "
  if ({{code}})
    string = ("* " + file_loc).colorize(:green).to_s + {{code.stringify}} + (" value: " + ({{code.receiver}}).inspect).colorize.mode(:dim).to_s
    if index = Assertions.hashes.index(hash)
      lines = Assertions.hashes.size - index
      print "\033[s\033[#{lines}A\033[K",string," (#{Assertions.counts[index]} more)", "\033[u"
      Assertions.counts[index] += 1
    else
      puts string
      Assertions.hashes << hash
      Assertions.counts << 1u64
    end
  else
    puts ("* " + file_loc).colorize(:red).to_s + {{code.stringify}} + (" value: " + ({{code.receiver}}).inspect).colorize.mode(:dim).to_s
    Assertions.hashes.clear
    Assertions.counts.clear
    if ENV["DEBUG"]? == "1"
      debugger
    end
  end
end
