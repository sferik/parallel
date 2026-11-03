# frozen_string_literal: true

require_relative "duel_helper"

# Four threads that share the items, so they're judged on the process's
# CPU time (only: :timing), as the items go to whichever thread asks
# first.

duel "threads: map 1,000 items", only: :timing do
  Parallel.map(INTEGERS, in_threads: 4) { |i| i }
end

duel "threads: each over 1,000 items", only: :timing do
  Parallel.each(INTEGERS, in_threads: 4) { |i| i }
end

duel "threads: map with finish_in_order", only: :timing do
  once { @finish = ->(_item, _index, _result) {} }
  Parallel.map(INTEGERS, in_threads: 4, finish: @finish, finish_in_order: true) { |i| i }
end

duel "threads: map a lambda's 1,000 items", only: :timing do
  Parallel.map(producer(1_000), in_threads: 4) { |i| i }
end

duel "threads: any? that's true at the last item", only: :timing do
  Parallel.any?(INTEGERS, in_threads: 4) { |i| i == 999 }
end

duel "threads: in_threads(4)", only: :timing do
  Parallel.in_threads(4) { |i| i }
end
