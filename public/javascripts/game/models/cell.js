class Cell {
  constructor(cell_data) {
    this.value = cell_data;
    this.opened = false;
  }

  render(x, y, cell_size) {
    if (this.opened) {
      this.draw_border(x, y, cell_size);
      this.draw_symbol(x, y, cell_size);
    } else {
      this.draw_closed(x, y, cell_size);
    }
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

  draw_closed(x, y, cell_size) {
    const border_width = Math.floor(cell_size / 10);
    const light = color("white");
    const dark = color("grey");
    const neutral = color("lightgrey");
    push();
    [
      ["left", light],
      ["top", light],
      ["right", dark],
      ["bottom", dark],
    ].forEach((i) => {
      const [side, color] = i;
      stroke(color);
      fill(color);
      this.border_segment(side, x, y, cell_size);
    });
    stroke(neutral);
    fill(neutral);
    rect(
      x + border_width,
      y + border_width,
      cell_size - 2 * border_width,
      cell_size - 2 * border_width
    );
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

  border_segment(side, x, y, s) {
    const b = 10; //border_width
    const tl_o = [0, 0];
    const tr_o = [s, 0];
    const br_o = [s, s];
    const bl_o = [0, s];
    const tl_i = [0 + b, 0 + b];
    const tr_i = [s - b, 0 + b];
    const br_i = [s - b, s - b];
    const bl_i = [0 + b, s - b];

    const segment_points = {
      l: [bl_o, tl_o, tl_i, bl_i],
      t: [tl_o, tr_o, tr_i, tl_i],
      r: [tr_o, br_o, br_i, tr_i],
      b: [br_o, bl_o, bl_i, br_i],
    };

    const side_translation = {
      left: "l",
      top: "t",
      right: "r",
      bottom: "b",
    };
    const segments = segment_points[side_translation[side]]
      .map((i) => {
        const [dx, dy] = i;
        return [x + dx, y + dy];
      })
      .flat();
    return quad(...segments);
  }

  clicked() {
    this.opened = !this.opened;
  }
}
