class InputHandler {
  constructor(canvas, viewport) {
    this.viewport = viewport;
    this.canvas = canvas;
    this.setup();
    this.min_zoom = 0.2;
    this.max_zoom = 3;
    this.is_dragging = false;
    this.previous_x = 0;
    this.previous_y = 0;

    this.zoom_handler = null;
    this.pan_handler = null;
  }

  setup() {
    window.mousePressed = (event) => {
      this.is_dragging = true;
      this.previous_x = event.clientX;
      this.previous_y = event.clientY;
    };
    window.mouseDragged = this.handle_drag.bind(this);
    window.mouseReleased = (event) => {
      this.previous_x = null;
      this.previous_y = null;
      this.is_dragging = false;
    };
    this.canvas.mouseWheel(this.handle_scroll.bind(this));
  }

  handle_scroll(scroll_event) {
    const { x, y, deltaY } = scroll_event;
    const direction = deltaY > 0 ? -1 : 1;
    this.zoom_handler(x, y, direction);
  }

  handle_drag(drag_event) {
    this.is_dragging = true;
    const new_x = drag_event.clientX;
    const new_y = drag_event.clientY;
    const dx = new_x - this.previous_x;
    const dy = new_y - this.previous_y;
    this.previous_x = new_x;
    this.previous_y = new_y;
    this.pan_handler(dx, dy);
  }
}
