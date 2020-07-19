require "core/chunk"

class PagesController < ApplicationController
  def home
    @test_text = Core::Chunk.test()
  end
end
