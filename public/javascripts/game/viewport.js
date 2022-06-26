class Viewport {
  constructor(x = 0, y = 0, zoom = 1) {
    this.x = x;
    this.y = y;
    this.zoom_level = 1;
    this.min_zoom = 0.2;
    this.max_zoom = 3;
    this.zoom_speed = 0.02;
  }

  apply() {
    translate(-this.x, -this.y);
    scale(this.zoom_level);
  }

  zoom(x, y, direction, width, height) {
    const zoom_delta = 1 * direction * this.zoom_speed;

    const dx = (x - this.x) / (width * this.zoom_level);
    const dy = (y - this.y) / (height * this.zoom_level);

    this.x += dx * width * zoom_delta;
    this.y += dy * height * zoom_delta;
    this.zoom_level = constrain(
      this.zoom_level + zoom_delta,
      this.min_zoom,
      this.max_zoom
    );
  }

  pan(dx, dy) {
    this.x -= dx;
    this.y -= dy;
  }

  absolute_to_relative(abs_x, abs_y) {
    const x = (abs_x + this.x) / this.zoom_level;
    const y = (abs_y + this.y) / this.zoom_level;
    return { x, y };
  }
}
