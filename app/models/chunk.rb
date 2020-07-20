class Chunk < ApplicationRecord
  before_save :ensure_binary_strings

  def position
    return { x: x, y: y }
  end

  def opened_positions
    return to_bin_array(bin_opened_positions, size)
  end

  def opened_positions=(new_positions)
    self.bin_opened_positions = new_positions
  end

  def mines
    return to_bin_array(bin_mine_positions, size)
  end

  def mines=(new_positions)
    self.bin_mine_positions = new_positions
  end

  def set_mine(x, y, value = 1)
    pos = size * y + x
    m = self.mines
    m[pos] = value
    self.mines = m
  end

  def to_bin_array(x, size)
    x = x[0, size * size]
    return BitArray.new(x.size, [x].pack("B*"), reverse_byte: false)
  end

  def ensure_binary_strings
    max_size = 128 * 128
    self.bin_mine_positions ||= BitArray.new(max_size)
    self.bin_opened_positions ||= BitArray.new(max_size)
    self.bin_mine_positions = self.bin_mine_positions.to_s.ljust(max_size, "0")
    self.bin_opened_positions = self.bin_opened_positions.to_s.ljust(max_size, "0")
  end
end
