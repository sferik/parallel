# frozen_string_literal: true

require_relative "duel_helper"

# The HMAC serializer frames, signs and checks every message that goes
# through a worker's pipe. Here it writes to memory and reads it back.

duel "serializer: HMAC dump and load an integer" do
  once do
    @serializer = Parallel::Serializer::Hmac.new(secret: "s" * 32)
    @io = StringIO.new
  end
  @io.rewind
  @serializer.dump(1, @io)
  @io.rewind
  @serializer.load(@io)
end

duel "serializer: HMAC dump and load a 16 KB string" do
  once do
    @serializer = Parallel::Serializer::Hmac.new(secret: "s" * 32)
    @io = StringIO.new
  end
  @io.rewind
  @serializer.dump(STRING_16KB, @io)
  @io.rewind
  @serializer.load(@io)
end
