class Chunk {
  constructor(data, chunk_size, cell_size) {
    let { x, y } = data;
    Object.assign(this, { x, y });

    this.cells = [];
    this.size = chunk_size;
    this.cell_size = cell_size;
    this.initialize(data["cells"]);
  }

  initialize(cells) {
    cells.forEach((cell) => {
      this.cells.push(new Cell(cell));
    });
  }

  render() {
    const chunk_size = this.size * this.cell_size;
    const x = this.x * chunk_size;
    const y = this.y * chunk_size;
    const s = this.size * this.cell_size;

    this.cells.forEach((cell, index) => {
      cell.render(
        x + (index % this.size) * this.cell_size,
        y + Math.floor(index / this.size) * this.cell_size,
        this.cell_size
      );
    });
  }

  clicked(cell_index) {
    this.cells[cell_index].clicked();
  }

  dimensions() {
    return this.cell_size * this.size;
  }
}
