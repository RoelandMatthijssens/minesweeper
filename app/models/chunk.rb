class Chunk < ApplicationRecord
  def position
    return { x: x, y: y }
  end

  def mines
    return to_bin_array(bin_mine_positions)
  end

  def to_bin_array(x)
    return BitArray.new(x.size, [x].pack("B*"), reverse_byte: false)
  end
end
