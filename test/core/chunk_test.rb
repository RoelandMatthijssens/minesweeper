require "test_helper"

class CoreChunkTest < ActiveSupport::TestCase
  test "get existing chunk" do
    Chunk.create!(x: 10, y: 12)
    chunk = Core::Chunks.get_or_create(10, 12)
    assert chunk.persisted?
  end
  test "get non existing chunk" do
    chunk = Core::Chunks.get_or_create(10, 12)
    assert_not chunk.persisted?
  end
  test "get chunk neighbours" do
    chunk = Chunk.new(x: 0, y: 0)
    neighbours = Core::Chunks.get_neighbours(chunk)
    neighbour_positions = neighbours.map { |x| x.position }
    expected_positions = [[-1, 0], [0, -1], [1, 0], [0, 1]].map { |x| { x: x[0], y: x[1] } }
    neighbour_positions.each do |expected_pos|
      assert neighbour_positions.include?(expected_pos)
    end
  end
end
