module Core
  module Chunks
    def get_neighbours(chunk)
      x = chunk.position[:x]
      y = chunk.position[:y]
      neighbour_positions = [
        [x - 1, y],
        [x, y - 1],
        [x + 1, y],
        [x, y + 1],
      ]
      return neighbour_positions.map { |pos| get_or_create(pos[0], pos[1]) }
    end

    def get_or_create(x, y)
      chunk = Chunk.where(x: x, y: y)
      if chunk.any?
        return chunk.first
      else
        return Chunk.new(x: x, y: y)
      end
    end

    def generate_mine_positions(chunk)
      mine_count = 3300
      chunk_size = 128 * 128
      random_positions = Set.new
      loop do
        random_positions << rand(chunk_size - 1)
        break if random_positions.size >= mine_count
      end
      mine_positions = BitArray.new(128 * 128)
      random_positions.each do |pos|
        mine_positions[pos] = 1
      end
      return mine_positions
    end

    module_function :get_neighbours
    module_function :get_or_create
    module_function :generate_mine_positions
  end
end
