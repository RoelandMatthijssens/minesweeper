class World {
  constructor(data) {
    const { chunk_size } = data;
    Object.assign(this, { chunk_size });

    this.cell_size = 100;
    this.canvas = canvas;
    this.chunks = [];
    this.initialize(data);
  }

  initialize(world_data) {
    world_data["chunks"].forEach((chunk_data) => {
      this.chunks.push(new Chunk(chunk_data, this.chunk_size));
    });
  }

  render() {
    this.chunks.forEach((chunk) => {
      chunk.render(this.cell_size);
    });
  }
}
