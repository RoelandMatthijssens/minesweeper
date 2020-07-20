require "rails_helper"

describe Core::Chunks do
  before :each do
    @chunk = Chunk.new(x: 0, y: 0, size: 10, mine_count: 10)
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
    it "should generate an amount of mines as defined by the chunk" do
      @chunk.mine_count = 12
      mines = Core::Chunks.generate_mine_positions(@chunk)
      expect(mines.total_set).to eq(12)
    end
    it "should not generate mines outside of chunk area" do
      @chunk.mine_count = 1
      @chunk.size = 3
      mines = Core::Chunks.generate_mine_positions(@chunk)
      expect(mines.to_s.index("1")).to be <= 9
    end
    describe "idempotency" do
      before :each do
        @chunk2 = Chunk.new(x: 1, y: 1, size: 10, mine_count: 10)
      end
      it "should be idempotent when generating mines for the same chunk" do
        mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
        mines_second_run = Core::Chunks.generate_mine_positions(@chunk)
        expect(mines_first_run.to_s).to eq(mines_second_run.to_s)
      end
      it "should be generate the same mine positions for a chunk on the same location" do
        @chunk2.x = 0
        @chunk2.y = 0
        mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
        mines_second_run = Core::Chunks.generate_mine_positions(@chunk2)
        expect(mines_first_run.to_s).to eq(mines_second_run.to_s)
      end
      it "should be generate different mine positions for a chunk on a different location x" do
        mines_first_run = Core::Chunks.generate_mine_positions(@chunk)
        mines_second_run = Core::Chunks.generate_mine_positions(@chunk2)
        expect(mines_first_run.to_s).to_not eq(mines_second_run.to_s)
      end
    end
  end

  describe "calculate cell values" do
    using RSpec::Parameterized::TableSyntax
    before :each do
    end
    describe "no border" do
      where(:x, :y, :expected) do
        1 | 1 | 1
        1 | 2 | 1
        1 | 3 | 1
        2 | 1 | 1
        2 | 2 | :mine
        2 | 3 | 2
        3 | 1 | 1
        3 | 2 | 2
        3 | 3 | :mine
      end
      with_them do
        it "should count mines in neighbouring cells" do
          chunk = Chunk.create!(x: 0, y: 0, size: 5, mine_count: 1)
          chunk.set_mine(2, 2)
          chunk.set_mine(3, 3)
          # -----------
          # | ? ? ? ? ?
          # | ? 1 1 1 ?
          # | ? 1 X 2 ?
          # | ? 1 2 X ?
          # | ? ? ? ? ?

          actual = Core::Chunks.calculate_cell_value(chunk, x, y)
          expect(actual).to eq(expected)
        end
      end
    end
    describe "against the border" do
    end
    describe "in the corner" do
    end
  end
end
