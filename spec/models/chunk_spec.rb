require "rails_helper"

describe Chunk do
  it "should calculate its position" do
    chunk = Chunk.new(x: 10, y: 15)
    assert chunk.position == { x: 10, y: 15 }
  end
end
