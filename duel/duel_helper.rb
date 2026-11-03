# frozen_string_literal: true

require "stringio"

# Parallel's own cost is the work around each item: handing it out,
# calling the block, collecting and ordering the results, and with
# processes, forking the workers and marshaling through their pipes. So
# every block here does next to nothing, and only Parallel is measured.

INTEGERS = Array.new(1_000) { |i| i }.freeze

# Fewer for processes and ractors, whose calls take longest to settle.
ITEMS = INTEGERS.first(200).freeze

# What the block returns for each item, to see what marshaling costs.
STRING_1KB = ("x" * 1_024).freeze
STRING_16KB = ("x" * 16_384).freeze

# A ractor can't run a block, so in_ractors calls a method.
module Work
  def self.call(item)
    item
  end
end

# A producer that hands out `count` items, then stops.
def producer(count, item = nil)
  index = -1
  -> { (index += 1) < count ? (item || index) : Parallel::Stop }
end

# A progress bar that writes to memory, at a fixed width (without a
# terminal, ruby-progressbar runs stty and tput for the width on every
# increment).
def progress
  { title: "Progress", output: StringIO.new, length: 80 }
end
