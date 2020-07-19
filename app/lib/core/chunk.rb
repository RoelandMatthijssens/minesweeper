module Core
  module Chunk
    def test
      return "test success"
    end

    module_function :test
  end
end
