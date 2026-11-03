# frozen_string_literal: true

require_relative "duel_helper"

# Two worker processes, forked for every call. The parent sends each
# item's index (or a producer's item) down a pipe and reads its result
# back, from a thread for each worker, so these are judged on the
# process's CPU time (only: :timing). The workers' own CPU time is
# worker_cpu (see .duel.rb). Each call is kept to a few milliseconds, as
# forking and the pipes make these the slowest to settle.

duel "processes: map 200 items", only: :timing do
  Parallel.map(ITEMS, in_processes: 2) { |i| i }
end

duel "processes: map to 16 KB strings", only: :timing do
  Parallel.map(ITEMS.first(50), in_processes: 2) { STRING_16KB }
end

duel "processes: map a lambda's 1 KB strings", only: :timing do
  Parallel.map(producer(200, STRING_1KB), in_processes: 2, &:bytesize)
end

duel "processes: map with the HMAC serializer", only: :timing do
  Parallel.map(ITEMS, in_processes: 2, serializer: Parallel::Serializer::Hmac.new) { |i| i }
end

duel "processes: any? that's true at the last item", only: :timing do
  Parallel.any?(ITEMS, in_processes: 2) { |i| i == 199 }
end
