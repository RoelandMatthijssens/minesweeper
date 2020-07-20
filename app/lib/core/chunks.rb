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
      seed = (Digest::SHA1.hexdigest("(#{chunk.x},#{chunk.y})").to_i(16)).to_f
      prng = Random.new(seed)
      random_positions = Set.new
      loop do
        random_positions << prng.rand(chunk.size * chunk.size - 1)
        break if random_positions.size >= chunk.mine_count
      end
      mine_positions = BitArray.new(chunk.size * chunk.size)
      random_positions.each do |pos|
        mine_positions[pos] = 1
      end
      return mine_positions
    end

    def calculate_cell_value(chunk, x, y)
      if chunk.is_mine?(x, y)
        return :mine
      end
      neighbouring_cell_positions = [
        [x - 1, y - 1],
        [x, y - 1],
        [x + 1, y - 1],
        [x - 1, y],
        # [x, y]
        [x + 1, y],
        [x - 1, y + 1],
        [x, y + 1],
        [x + 1, y + 1],
      ]
      return neighbouring_cell_positions.map { |x| chunk.is_mine?(x[0], x[1]) ? 1 : 0 }.reduce(&:+)
    end

    module_function :get_neighbours
    module_function :get_or_create
    module_function :generate_mine_positions
    module_function :calculate_cell_value
  end
end
