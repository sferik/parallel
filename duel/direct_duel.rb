# frozen_string_literal: true

require_relative "duel_helper"

# With 0 workers, Parallel runs every item in the calling thread, as
# `in_processes: 0` does where forking is turned off. It's the same work
# for each item that threads and processes do (handing it out, calling
# the block, the callbacks, collecting the result), with nothing else in
# the way, so it's timed and counted exactly.

duel "direct: map 1,000 items" do
  Parallel.map(INTEGERS, in_threads: 0) { |i| i }
end

duel "direct: each over 1,000 items" do
  Parallel.each(INTEGERS, in_threads: 0) { |i| i }
end

duel "direct: map_with_index over 1,000 items" do
  Parallel.map_with_index(INTEGERS, in_threads: 0) { |i, index| i + index }
end

duel "direct: flat_map over 1,000 items" do
  Parallel.flat_map(INTEGERS, in_threads: 0) { |i| [i, i] }
end

duel "direct: filter_map over 1,000 items" do
  Parallel.filter_map(INTEGERS, in_threads: 0) { |i| i if i.even? }
end

duel "direct: any? that's true at the last item" do
  Parallel.any?(INTEGERS, in_threads: 0) { |i| i == 999 }
end

duel "direct: all? of 1,000 items" do
  Parallel.all?(INTEGERS, in_threads: 0) { |i| i >= 0 }
end

duel "direct: map a range" do
  Parallel.map(0...1_000, in_threads: 0) { |i| i }
end

duel "direct: map with start and finish callbacks" do
  once do
    @start = ->(_item, _index) {}
    @finish = ->(_item, _index, _result) {}
  end
  Parallel.map(INTEGERS, in_threads: 0, start: @start, finish: @finish) { |i| i }
end

duel "direct: map with finish_in_order" do
  once { @finish = ->(_item, _index, _result) {} }
  Parallel.map(INTEGERS, in_threads: 0, finish: @finish, finish_in_order: true) { |i| i }
end

duel "direct: map with a progress bar" do
  Parallel.map(INTEGERS, in_threads: 0, progress: progress) { |i| i }
end

duel "direct: map a lambda's 1,000 items" do
  Parallel.map(producer(1_000), in_threads: 0) { |i| i }
end

duel "direct: map a queue's 1,000 items" do |n|
  queues = untimed { Array.new(n) { Queue.new(INTEGERS + [Parallel::Stop]) } }
  queues.each { |queue| Parallel.map(queue, in_threads: 0) { |i| i } }
end

duel "direct: break at the last item" do
  Parallel.map(INTEGERS, in_threads: 0) { |i| i == 999 ? raise(Parallel::Break, i) : i }
end
