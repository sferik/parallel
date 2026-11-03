# frozen_string_literal: true

require_relative "duel_helper"

Warning[:experimental] = false # (Ractor is experimental, Ruby warns)

# Two ractors, made for every call, which call Work.call on each item.

duel "ractors: map 200 items", only: :timing do
  Parallel.map(ITEMS, in_ractors: 2, ractor: [Work, :call])
end
