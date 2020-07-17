class Chunk < ApplicationRecord
  def position
    return { x: x, y: y }
  end
end
