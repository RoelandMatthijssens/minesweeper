class InputHandler {
  constructor(canvas, viewport) {
    this.viewport = viewport;
    this.canvas = canvas;
    this.setup();
    this.min_zoom = 0.2;
    this.max_zoom = 3;
  }

  setup() {
    window.mousePressed = (event) => {
      console.log("mouse pressed");
    };
    window.mouseDragged = (event) => {
      console.log("mouse dragged");
    };
    window.mouseReleased = (event) => {
      console.log("mouse released");
    };
    this.canvas.mouseWheel(this.handle_zoom.bind(this));
  }

  handle_zoom(scroll_event) {
    const { x, y, deltaY } = scroll_event;
    const { x: viewport_x, y: viewport_y, zoom: viewport_zoom } = this.viewport;
    const { height, width } = this.canvas;

    const direction = deltaY > 0 ? -1 : 1;
    const zoom_factor = 0.05;
    const zoom_delta = 1 * direction * zoom_factor;

    const x_delta = (x - viewport_x) / (width * viewport_zoom);
    const y_delta = (y - viewport_y) / (height * viewport_zoom);

    this.viewport.x -= x_delta * width * zoom_delta;
    this.viewport.y -= y_delta * height * zoom_delta;
    this.viewport.zoom = constrain(
      viewport_zoom + zoom_delta,
      this.min_zoom,
      this.max_zoom
    );
  }
}
