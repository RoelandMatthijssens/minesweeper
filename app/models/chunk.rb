class Chunk < ApplicationRecord
  def position
    return [x, y]
  end
end
