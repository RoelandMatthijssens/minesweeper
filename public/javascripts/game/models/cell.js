class Cell {
  constructor(cell_data) {
    this.value = cell_data;
  }

  render(x, y, cell_size) {
    console.log("rendering cell");
    push();
    stroke(color("green"));
    rect(x, y, cell_size, cell_size);
    textAlign(CENTER);
    text(this.value, x + cell_size / 2, y + cell_size / 2);
    pop();
  }
}
