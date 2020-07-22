require "rails_helper"

describe Core::Chunks do
  before :each do
    @chunk = Chunk.new(x: 0, y: 0, size: 10, mine_count: 10)
  end
  describe "get by position" do
    describe "with existing chunk" do
      it "should find the existing chunk" do
        @chunk.save!
        chunk = Core::Chunks.get_or_create(0, 0, 10)
        expect(chunk).to be_a(Chunk)
        expect(chunk).to be_persisted
      end
    end
    describe "without existing chunk" do
      it "should create a new chunk" do
        chunk = Core::Chunks.get_or_create(0, 0, 10)
        expect(chunk).to be_a(Chunk)
        expect(chunk).to be_persisted
      end
    end
  end

  describe "get neighbours" do
    it "should fetch all eight neighbours" do
      expect(Core::Chunks.get_neighbours(@chunk).count).to eq(8)
    end
    it "should label each neighbour" do
      labels = [:top_left, :top_middle, :top_right, :middle_left, :middle_right, :bottom_left, :bottom_middle, :bottom_right]
      expect(Core::Chunks.get_neighbours(@chunk).keys).to contain_exactly(*labels)
    end
    it "should have the chunk on the right position matching the labels" do
      labels = {
        top_left: { x: -1, y: -1 },
        top_middle: { x: 0, y: -1 },
        top_right: { x: 1, y: -1 },

        middle_left: { x: -1, y: 0 },
        middle_right: { x: 1, y: 0 },

        bottom_left: { x: -1, y: 1 },
        bottom_middle: { x: 0, y: 1 },
        bottom_right: { x: 1, y: 1 },
      }
      labels.each do |label, position|
        expect(Core::Chunks.get_neighbours(@chunk)[label].position).to eq(position)
      end
    end
    it "shouldnt matter if a neighbouring chunk existed or not" do
      Chunk.create!(x: -1, y: 0)
      Chunk.create!(x: -1, y: -1)
      Chunk.create!(x: 1, y: 1)
      labels = {
        top_left: { x: -1, y: -1 },
        top_middle: { x: 0, y: -1 },
        top_right: { x: 1, y: -1 },

        middle_left: { x: -1, y: 0 },
        middle_right: { x: 1, y: 0 },

        bottom_left: { x: -1, y: 1 },
        bottom_middle: { x: 0, y: 1 },
        bottom_right: { x: 1, y: 1 },
      }
      labels.each do |label, position|
        expect(Core::Chunks.get_neighbours(@chunk)[label].position).to eq(position)
      end
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
      # -------------
      # |           |
      # |   1 1 1   |
      # |   1 X 2   |
      # |   1 2 X   |
      # |           |
      # -------------
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
          chunk = Chunk.create!(x: 0, y: 0, size: 5, mine_count: 2)
          chunk.set_mine(2, 2)
          chunk.set_mine(3, 3)
          chunk.save!

          actual = Core::Chunks.calculate_cell_value(chunk, x, y)
          expect(actual).to eq(expected)
        end
      end
    end
    describe "against the border" do
      # -------------------------
      # |       |       |       |
      # |       |       |       |
      # |       | X     |       |
      # -------------------------
      # |       |   1   |       |
      # |       | 1   2 | X     |
      # |       | X 4   | X     |
      # -------------------------
      # |       | X X X |       |
      # |       |       |       |
      # |       |       |       |
      # -------------------------
      where(:x, :y, :expected) do
        1 | 0 | 1
        0 | 1 | 1
        2 | 1 | 2
        1 | 2 | 4
      end
      with_them do
        it "should consider cells in neighbouring chunks" do
          chunk_1_1 = Chunk.create!(x: 1, y: 1, size: 3, mine_count: 1)
          chunk_1_1.set_mine(0, 2)
          chunk_1_1.save!()

          chunk_0_1 = Chunk.create!(x: 0, y: 1, size: 3, mine_count: 0)

          chunk_2_1 = Chunk.create!(x: 2, y: 1, size: 3, mine_count: 2)
          chunk_2_1.set_mine(0, 1)
          chunk_2_1.set_mine(0, 2)
          chunk_2_1.save!()

          chunk_1_0 = Chunk.create!(x: 1, y: 0, size: 3, mine_count: 1)
          chunk_1_0.set_mine(0, 2)
          chunk_1_0.save!()

          chunk_1_2 = Chunk.create!(x: 1, y: 2, size: 3, mine_count: 3)
          chunk_1_2.set_mine(0, 0)
          chunk_1_2.set_mine(1, 0)
          chunk_1_2.set_mine(2, 0)
          chunk_1_2.save!()

          actual = Core::Chunks.calculate_cell_value(chunk_1_1, x, y)
          expect(actual).to eq(expected)
        end
      end
    end
    describe "in the corner" do
      # -------------------------
      # |       |       |       |
      # |       |       |       |
      # |     X |       |       |
      # -------------------------
      # |       | 1   0 |       |
      # |       |       |       |
      # |       | 2 X 1 |       |
      # -------------------------
      # |     X |       |   X   |
      # |       |       | X     |
      # |       |       |       |
      # -------------------------
      where(:x, :y, :expected) do
        0 | 0 | 1
        2 | 0 | 0
        0 | 2 | 2
        2 | 2 | 1
      end
      with_them do
        it "should consider cells in neighbouring chunks" do
          chunk_1_1 = Chunk.create!(x: 1, y: 1, size: 3, mine_count: 1)
          chunk_1_1.set_mine(1, 2)
          chunk_1_1.save!()

          chunk_0_0 = Chunk.create!(x: 0, y: 0, size: 3, mine_count: 1)
          chunk_0_0.set_mine(2, 2)
          chunk_0_0.save!()

          chunk_2_0 = Chunk.create!(x: 2, y: 0, size: 3, mine_count: 0)

          chunk_0_2 = Chunk.create!(x: 0, y: 2, size: 3, mine_count: 1)
          chunk_0_2.set_mine(2, 0)
          chunk_0_2.save!()

          chunk_2_2 = Chunk.create!(x: 2, y: 2, size: 3, mine_count: 2)
          chunk_2_2.set_mine(1, 0)
          chunk_2_2.set_mine(0, 1)
          chunk_2_2.save!()

          actual = Core::Chunks.calculate_cell_value(chunk_1_1, x, y)
          expect(actual).to eq(expected)
        end
      end
    end
    describe "random full field" do
      # -------------------------
      # |       |     X |       |
      # | X     |       |       |
      # |     X |       |       |
      # -------------------------
      # | X     |   X   |   X   |
      # |     X |       | X X   |
      # |       |     X |       |
      # -------------------------
      # |       |     X |     X |
      # |       |     X |       |
      # |       | X     |       |
      # -------------------------
      where(:cx, :cy, :expected_values) do
        [
          [0, 0, [[1, 1, 0], [:mine, 2, 1], [2, 3, :mine]]],
          [1, 0, [[0, 1, :mine], [1, 1, 1], [2, 1, 1]]],
          [2, 0, [[1, 0, 0], [1, 0, 0], [1, 1, 1]]],
          [0, 1, [[:mine, 3, 2], [1, 2, :mine], [0, 1, 1]]],
          [1, 1, [[3, :mine, 2], [2, 2, 3], [1, 2, :mine]]],
          [2, 1, [[3, :mine, 2], [:mine, :mine, 2], [4, 3, 2]]],
          [0, 2, [[0, 0, 0], [0, 0, 1], [0, 0, 1]]],
          [1, 2, [[0, 3, :mine], [1, 3, :mine], [:mine, 2, 1]]],
          [2, 2, [[3, 1, :mine], [2, 1, 1], [1, 0, 0]]],
        ]
      end
      with_them do
        it "should consider cells in neighbouring chunks" do
          chunk_0_0 = Chunk.create!(x: 0, y: 0, size: 3, mine_count: 2)
          chunk_0_1 = Chunk.create!(x: 0, y: 1, size: 3, mine_count: 2)
          chunk_0_2 = Chunk.create!(x: 0, y: 2, size: 3, mine_count: 0)
          chunk_1_0 = Chunk.create!(x: 1, y: 0, size: 3, mine_count: 1)
          chunk_1_1 = Chunk.create!(x: 1, y: 1, size: 3, mine_count: 2)
          chunk_1_2 = Chunk.create!(x: 1, y: 2, size: 3, mine_count: 3)
          chunk_2_0 = Chunk.create!(x: 2, y: 0, size: 3, mine_count: 0)
          chunk_2_1 = Chunk.create!(x: 2, y: 1, size: 3, mine_count: 3)
          chunk_2_2 = Chunk.create!(x: 2, y: 2, size: 3, mine_count: 1)

          chunk_0_0.set_mine(0, 1)
          chunk_0_0.set_mine(2, 2)
          chunk_0_0.save!()
          chunk_0_1.set_mine(0, 0)
          chunk_0_1.set_mine(2, 1)
          chunk_0_1.save!()
          chunk_0_2.save!()
          chunk_1_0.set_mine(2, 0)
          chunk_1_0.save!()
          chunk_1_1.set_mine(1, 0)
          chunk_1_1.set_mine(2, 2)
          chunk_1_1.save!()
          chunk_1_2.set_mine(2, 0)
          chunk_1_2.set_mine(2, 1)
          chunk_1_2.set_mine(0, 2)
          chunk_1_2.save!()
          chunk_2_0.save!()
          chunk_2_1.set_mine(1, 0)
          chunk_2_1.set_mine(0, 1)
          chunk_2_1.set_mine(1, 1)
          chunk_2_1.save!()
          chunk_2_2.set_mine(2, 0)
          chunk_2_2.save!()

          chunk = Core::Chunks.get_or_create(cx, cy, 3)
          [0, 1, 2].each do |x|
            [0, 1, 2].each do |y|
              expected = expected_values[y][x]
              actual = Core::Chunks.calculate_cell_value(chunk, x, y)
              expect(actual).to eq(expected)
            end
          end
        end
      end
    end
  end

  describe "relative_to_absolute_position" do
    where(:chunk, :pos, :offset, :result_pos, :result_chunk) do
      [
        [[0, 0, 10], [0, 0], [1, 0], [1, 0], [0, 0]],
        [[0, 0, 10], [0, 0], [-1, 0], [9, 0], [-1, 0]],
        [[0, 0, 10], [0, 0], [0, -1], [0, 9], [0, -1]],
        [[0, 0, 10], [0, 0], [-1, -1], [9, 9], [-1, -1]],
        [[0, 0, 10], [9, 9], [1, 0], [0, 9], [1, 0]],
        [[0, 0, 10], [9, 9], [-1, 0], [8, 9], [0, 0]],
        [[0, 0, 10], [9, 9], [0, 1], [9, 0], [0, 1]],
        [[0, 0, 10], [9, 9], [1, 1], [0, 0], [1, 1]],
        [[0, 0, 10], [0, 0], [10, 0], [0, 0], [1, 0]],
        [[0, 0, 10], [0, 0], [15, 0], [5, 0], [1, 0]],
        [[0, 0, 10], [0, 0], [21, 0], [1, 0], [2, 0]],
        [[0, 0, 10], [0, 0], [-21, 0], [9, 0], [-3, 0]],

        [[1, 1, 3], [1, 0], [-1, -1], [0, 2], [1, 0]],
      ]
    end
    with_them do
      it "should count mines in neighbouring cells" do
        @chunk = Chunk.create!(x: chunk[0], y: chunk[1], size: chunk[2])
        result = Core::Chunks.relative_to_absolute_position(@chunk, pos[0], pos[1], offset[0], offset[1])
        position = result[:pos]
        chunk = result[:chunk]

        expect(position[:x]).to eq(result_pos[0])
        expect(position[:y]).to eq(result_pos[1])
        expect(chunk.position[:x]).to eq(result_chunk[0])
        expect(chunk.position[:y]).to eq(result_chunk[1])
      end
    end
  end
end
