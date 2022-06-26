class World {
  constructor(canvas) {
    this.cell_size = 80;
    this.canvas = canvas;
    this.chunks = [];
    this.viewport = new Viewport();
    this.input_handler = new InputHandler(this.canvas, this.viewport);

    this.input_handler.zoom_handler = (x, y, d) => {
      this.viewport.zoom(x, y, d, this.canvas.width, this.canvas.height);
    };
    this.input_handler.pan_handler = this.viewport.pan.bind(this.viewport);
    this.input_handler.click_handler = this.handle_click.bind(this);
  }

  initialize(data) {
    const { chunk_size } = data;
    this.chunk_size = chunk_size;
    data["chunks"].forEach((chunk_data) => {
      this.chunks.push(new Chunk(chunk_data, chunk_size, this.cell_size));
    });
  }

  render() {
    this.viewport.apply();
    this.chunks.forEach((chunk) => {
      chunk.render();
    });
  }

  handle_click(x, y) {
    const chunk = this.get_chunk(x, y);
    const cell_index = this.get_index_in_chunk(chunk, x, y);
    if (chunk != null && cell_index != null) {
      chunk.clicked(cell_index);
    }
  }

  get_chunk(abs_x, abs_y) {
    let result = null;
    const { x, y } = this.viewport.absolute_to_relative(abs_x, abs_y);
    this.chunks.some((chunk) => {
      if (
        x > chunk.x * chunk.dimensions() &&
        x < (chunk.x + 1) * chunk.dimensions() &&
        y > chunk.y * chunk.dimensions() &&
        y < (chunk.y + 1) * chunk.dimensions()
      ) {
        result = chunk;
      }
    });
    return result;
  }

  get_index_in_chunk(chunk, abs_x, abs_y) {
    if (!chunk) {
      return;
    }
    const { x, y } = this.viewport.absolute_to_relative(abs_x, abs_y);
    const dx_cell = x - chunk.x * chunk.dimensions();
    const dy_cell = y - chunk.y * chunk.dimensions();
    const cell_x_index = Math.floor(dx_cell / this.cell_size);
    const cell_y_index = Math.floor(dy_cell / this.cell_size);
    return cell_y_index * this.chunk_size + cell_x_index;
  }
}
