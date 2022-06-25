class Cell {
  constructor(cell_data) {
    this.value = cell_data;
  }

  render(x, y, cell_size) {
    this.draw_border(x, y, cell_size);
    this.draw_symbol(x, y, cell_size);
  }

  draw_border(x, y, cell_size) {
    push();
    strokeWeight(4);
    stroke(color("darkGray"));
    fill(color("lightGray"));
    rect(x, y, cell_size, cell_size);
    pop();
  }

  draw_symbol(x, y, cell_size) {
    const color = this.symbol_color();
    push();
    stroke(color);
    fill(color);
    strokeWeight(2);
    textSize(Math.floor(cell_size / 2.5));
    textAlign(CENTER, CENTER);
    text(this.symbol(), x + cell_size / 2, y + cell_size / 2);
    pop();
  }

  symbol() {
    return {
      1: 1,
      2: 2,
      3: 3,
      4: 4,
      5: 5,
      6: 6,
      7: 7,
      8: 8,
      9: 9,
      0: "",
      flag: "🚩",
      bomb: "💣",
    }[this.value];
  }

  symbol_color() {
    return {
      1: "blue",
      2: "green",
      3: "crimson",
      4: "darkBlue",
      5: "darkRed",
      6: "darkCyan",
      7: "black",
      8: "darkGrey",
      9: "fuchsia",
      0: "white",
      flag: "lightGreen",
      bomb: "black",
    }[this.value];
  }
}
