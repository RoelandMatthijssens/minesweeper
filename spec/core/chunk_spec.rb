require "rails_helper"

describe Core::Chunks do
  describe "get by position" do
    describe "with existing chunk" do
      before :each do
        Chunk.create!(x: 10, y: 12)
      end
      it "should find the existing chunk" do
        chunk = Core::Chunks.get_or_create(10, 12)
        expect(chunk).not_to be_a_new(Chunk)
      end
    end
    describe "without existing chunk" do
      it "should create a new unsaved chunk" do
        chunk = Core::Chunks.get_or_create(10, 12)
        expect(chunk).to be_a_new(Chunk)
      end
    end
  end

  describe "get neighbours" do
    it "should contain the four neighbours" do
      chunk = Chunk.new(x: 0, y: 0)
      neighbours = Core::Chunks.get_neighbours(chunk)
      neighbour_positions = neighbours.map { |x| x.position }
      expected_positions = [[-1, 0], [0, -1], [1, 0], [0, 1]].map { |x| { x: x[0], y: x[1] } }
      expect(neighbour_positions).to contain_exactly(*expected_positions)
    end
  end
end
