class InputHandler {
  constructor(canvas, viewport) {
    this.viewport = viewport;
    this.canvas = canvas;
    this.setup();
    this.min_zoom = 0.2;
    this.max_zoom = 3;

    this.zoom_handler = null;
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
    this.canvas.mouseWheel(this.handle_scroll.bind(this));
  }

  handle_scroll(scroll_event) {
    const { x, y, deltaY } = scroll_event;
    const direction = deltaY > 0 ? -1 : 1;
    this.zoom_handler(x, y, direction);
  }
}
