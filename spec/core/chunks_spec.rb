require "rails_helper"

describe Core::Chunks do
  before :each do
    @chunk = Chunk.new(x: 0, y: 0)
  end
  describe "get by position" do
    describe "with existing chunk" do
      it "should find the existing chunk" do
        @chunk.save!
        chunk = Core::Chunks.get_or_create(0, 0)
        expect(chunk).not_to be_a_new(Chunk)
      end
    end
    describe "without existing chunk" do
      it "should create a new unsaved chunk" do
        chunk = Core::Chunks.get_or_create(0, 0)
        expect(chunk).to be_a_new(Chunk)
      end
    end
  end

  describe "get neighbours" do
    it "should contain the four neighbours" do
      neighbours = Core::Chunks.get_neighbours(@chunk)
      neighbour_positions = neighbours.map { |x| x.position }
      expected_positions = [[-1, 0], [0, -1], [1, 0], [0, 1]].map { |x| { x: x[0], y: x[1] } }
      expect(neighbour_positions).to contain_exactly(*expected_positions)
    end
    it "shouldnt matter if a neighbouring chunk existed or not" do
      Chunk.create!(x: -1, y: 0)
      neighbours = Core::Chunks.get_neighbours(@chunk)
      neighbour_positions = neighbours.map { |x| x.position }
      expected_positions = [[-1, 0], [0, -1], [1, 0], [0, 1]].map { |x| { x: x[0], y: x[1] } }
      expect(neighbour_positions).to contain_exactly(*expected_positions)
    end
  end

  describe "Generate mine positions" do
    it "should generate 3300 mines per chunk" do
      mines = Core::Chunks.generate_mine_positions(@chunk)
      expect(mines.total_set).to eq(3300)
    end
    it "should be idempotent when generating mines for the same chunk" do
      mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
      mines_second_run = Core::Chunks.generate_mine_positions(@chunk)
      expect(mines_first_run.to_s).to eq(mines_second_run.to_s)
    end
    it "should be generate the same mine positions for a chunk on the same location" do
      mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
      mines_second_run = Core::Chunks.generate_mine_positions(Chunk.new(x: @chunk.x, y: @chunk.y))
      expect(mines_first_run.to_s).to eq(mines_second_run.to_s)
    end
    it "should be generate different mine positions for a chunk on a different location x" do
      mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
      mines_second_run = Core::Chunks.generate_mine_positions(Chunk.new(x: @chunk.x + 1, y: @chunk.y))
      expect(mines_first_run.to_s).to_not eq(mines_second_run.to_s)
    end
    it "should be generate different mine positions for a chunk on a different location y" do
      mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
      mines_second_run = Core::Chunks.generate_mine_positions(Chunk.new(x: @chunk.x, y: @chunk.y + 1))
      expect(mines_first_run.to_s).to_not eq(mines_second_run.to_s)
    end
  end
end
