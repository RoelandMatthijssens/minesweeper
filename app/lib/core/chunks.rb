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

    module_function :get_neighbours

    def get_or_create(x, y)
      chunk = Chunk.where(x: x, y: y)
      if chunk.any?
        return chunk.first
      else
        return Chunk.new(x: x, y: y)
      end
    end

    module_function :get_or_create
  end
end
