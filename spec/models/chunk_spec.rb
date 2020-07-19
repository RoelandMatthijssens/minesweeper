require "rails_helper"

describe Chunk do
  before :each do
    @chunk = Chunk.new(x: 10, y: 15, size: 10)
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
  it "should have a binary string for the opened positions" do
    opened_positions = BitArray.new(10 * 10)
    opened_positions[0] = 1
    opened_positions[2] = 1
    opened_positions[10 * 10 - 1] = 1
    Chunk.create!(bin_opened_positions: opened_positions, size: 10)
    chunk = Chunk.first
    expect(chunk.opened_positions[0]).to eq(1)
    expect(chunk.opened_positions[1]).to eq(0)
    expect(chunk.opened_positions[2]).to eq(1)
    expect(chunk.opened_positions[3]).to eq(0)
    expect(chunk.opened_positions[10 * 10 - 1]).to eq(1)
    expect(chunk.opened_positions.total_set).to eq(3)
  end
  it "should have a binary string for the mine positions" do
    mines = BitArray.new(12 * 12)
    mines[0] = 1
    mines[2] = 1
    mines[12 * 12 - 1] = 1
    Chunk.create!(bin_mine_positions: mines, size: 12)
    chunk = Chunk.first
    expect(chunk.mines[0]).to eq(1)
    expect(chunk.mines[1]).to eq(0)
    expect(chunk.mines[2]).to eq(1)
    expect(chunk.mines[3]).to eq(0)
    expect(chunk.mines[12 * 12 - 1]).to eq(1)
    expect(chunk.mines.total_set).to eq(3)
  end
end
