require "rails_helper"

describe Chunk do
  before :each do
    @chunk = Chunk.create!(x: 10, y: 15)
  end
  it "should calculate its position" do
    expect(@chunk.position).to eq({ x: 10, y: 15 })
  end
  it "should take the chunk size into account when fetching opened_positions" do
    @chunk.size = 15
    @chunk.save!
    expect(@chunk.opened_positions.size).to eq(15 * 15)
  end
  it "should take the chunk size into account when storing mine_positions" do
    @chunk.size = 21
    @chunk.save!
    expect(@chunk.mines.size).to eq(21 * 21)
  end
  describe "update binary string positions" do
    it "should update the opened positions when passing a bit array" do
      random_position = rand(@chunk.size * @chunk.size - 1)
      opened_pos = @chunk.opened_positions
      opened_pos[random_position] = 1
      @chunk.opened_positions = opened_pos
      @chunk.save!
      reloaded_positions = Chunk.first.opened_positions
      expect(reloaded_positions[random_position]).to eq(1)
    end
    it "should update the mine positions when passing a bit array" do
      random_position = rand(@chunk.size * @chunk.size - 1)
      mines = @chunk.mines
      mines[random_position] = 1
      @chunk.mines = mines
      @chunk.save!
      reloaded_mines = Chunk.first.mines
      expect(reloaded_mines[random_position]).to eq(1)
    end
  end
  describe "set mine" do
    it "should set a mine at the given x y position" do
      @chunk.set_mine(0, 0)
      mines = @chunk.mines
      expect(mines[0]).to eq(1)
    end
    it "should set a mine at the given x y position" do
      @chunk.size = 10
      @chunk.set_mine(3, 3)
      mines = @chunk.mines
      expect(mines[33]).to eq(1)
    end
    it "should toggle mines of" do
      @chunk.set_mine(3, 3)
      expect(@chunk.mines.total_set).to eq(1)
      @chunk.set_mine(3, 3, value = 0)
      expect(@chunk.mines.total_set).to eq(0)
    end
  end
end
