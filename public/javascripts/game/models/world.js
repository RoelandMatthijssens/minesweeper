class World {
  constructor(canvas) {
    this.cell_size = 100;
    this.canvas = canvas;
    this.chunks = [];
    this.viewport = new Viewport(this.canvas.width / 2, this.canvas.height / 2);
    this.input_handler = new InputHandler(this.canvas, this.viewport);
  }

  initialize(world_data) {
    const { chunk_size } = world_data;
    this.chunk_size = chunk_size;
    world_data["chunks"].forEach((chunk_data) => {
      this.chunks.push(new Chunk(chunk_data, chunk_size));
    });
  }

  render() {
    this.viewport.apply();
    this.chunks.forEach((chunk) => {
      chunk.render(this.cell_size);
    });
  }
}
