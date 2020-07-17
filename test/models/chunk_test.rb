require "test_helper"

class ChunkTest < ActiveSupport::TestCase
  test "position" do
    chunk = Chunk.new(x: 10, y: 15)
    assert chunk.position == { x: 10, y: 15 }
  end
end
