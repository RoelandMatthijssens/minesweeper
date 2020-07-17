require "test_helper"

class CoreChunkTest < ActiveSupport::TestCase
  test "get chunk neighbours" do
    chunk = Chunk.new(x: 0, y: 0)
    assert chunk.position == [0, 0]
  end
end
