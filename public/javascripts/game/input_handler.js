class InputHandler {
  constructor(canvas, viewport) {
    this.viewport = viewport;
    this.canvas = canvas;
    this.setup();
    this.min_zoom = 0.2;
    this.max_zoom = 3;
    this.is_dragging = false;
    this.did_drag = false;
    this.previous_x = 0;
    this.previous_y = 0;

    this.zoom_handler = null;
    this.pan_handler = null;
    this.click_handler = null;
  }

  setup() {
    window.mousePressed = this.prepare_drag.bind(this);
    window.mouseDragged = this.handle_drag.bind(this);
    window.mouseReleased = this.handle_click.bind(this);
    this.canvas.mouseWheel(this.handle_scroll.bind(this));
  }

  handle_scroll(scroll_event) {
    const { x, y, deltaY } = scroll_event;
    const direction = deltaY > 0 ? -1 : 1;
    this.zoom_handler(x, y, direction);
  }

  handle_drag(drag_event) {
    this.is_dragging = true;
    this.did_drag = true;
    const new_x = drag_event.clientX;
    const new_y = drag_event.clientY;
    const dx = new_x - this.previous_x;
    const dy = new_y - this.previous_y;
    this.previous_x = new_x;
    this.previous_y = new_y;
    this.pan_handler(dx, dy);
  }

  handle_click(click_event) {
    this.previous_x = null;
    this.previous_y = null;
    this.is_dragging = false;
    if (this.did_drag) {
      this.did_drag = false;
      return;
    }
    const { clientX: x, clientY: y } = click_event;
    this.click_handler(x, y);
  }
  prepare_drag(click_event) {
    // drag events only have the destination position of the drag, not the start position. In order to calculate the
    // correct drag delta we need to keep track of where we started the drag, aka, the initial click position.
    // This method stores it temporarily in case we do start dragging.
    this.previous_x = click_event.clientX;
    this.previous_y = click_event.clientY;
  }
}
