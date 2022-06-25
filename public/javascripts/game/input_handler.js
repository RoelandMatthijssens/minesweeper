class InputHandler {
  constructor(canvas, viewport) {
    this.viewport = viewport;
    this.canvas = canvas;
    this.setup();
  }

  setup() {
    console.log(this);
    console.log("aaa");
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

    const direction = deltaY > 0 ? "up" : "down";
    const current_zoom = this.viewport.zoom;

    if (direction == "up") {
      this.viewport.zoom = Math.min(current_zoom + 0.2, 3);
    } else {
      this.viewport.zoom = Math.max(0.2, current_zoom - 0.2);
    }
  }
}
