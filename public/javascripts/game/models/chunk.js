class Chunk {
  constructor(data, chunk_size) {
    let { x, y } = data;
    Object.assign(this, { x, y });

    this.cells = [];
    this.size = chunk_size;
    this.initialize(data["cells"]);
  }

  initialize(cells) {
    cells.forEach((cell) => {
      this.cells.push(new Cell(cell));
    });
  }

  render(cell_size) {
    const chunk_size = this.size * cell_size;
    const x = this.x * chunk_size;
    const y = this.y * chunk_size;
    const s = this.size * cell_size;

    push();
    stroke(color("red"));
    rect(x, y, s, s);
    pop();

    this.cells.forEach((cell, index) => {
      console.log(index);
      cell.render(
        x + (index % this.size) * cell_size,
        y + Math.floor(index / this.size) * cell_size,
        cell_size
      );
    });
  }
}
