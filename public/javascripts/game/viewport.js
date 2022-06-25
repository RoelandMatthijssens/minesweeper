class Viewport {
  constructor(x = 0, y = 0, zoom = 1) {
    this.x = x;
    this.y = y;
    this.zoom = 1;
  }

  apply() {
    translate(this.x, this.y);
    scale(this.zoom);
  }
}
