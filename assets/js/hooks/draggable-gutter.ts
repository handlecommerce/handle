import { Hook, makeHook } from "phoenix_typed_hook";



class DraggableGutter extends Hook {
  private pointerEvents: string;

  private parent: HTMLElement;
  private leftPane: HTMLElement;
  private rightPane: HTMLElement;

  mounted() {
    this.onMouseUp = this.onMouseUp.bind(this);
    this.onMouseMove = this.onMouseMove.bind(this);

    this.parent = this.el.parentElement!;
    this.leftPane = this.parent.firstElementChild! as HTMLElement;
    this.rightPane = this.parent.lastElementChild! as HTMLElement;

    this.el.addEventListener("mousedown", (e) => {
      console.log("Mouse Down");
      document.addEventListener("mousemove", this.onMouseMove);
      document.addEventListener("mouseup", this.onMouseUp);

      if (this.rightPane) {
        this.pointerEvents = this.rightPane.style.pointerEvents;
        this.rightPane.style.pointerEvents = "none";
      }
    });
  }

  onMouseMove(e: MouseEvent) {
    // Get offset
    const containerOffsetLeft = this.parent.offsetLeft;

    // Get x-coordinate of pointer relative to container
    const pointerRelativeXpos = e.clientX - containerOffsetLeft;

    // Arbitrary minimum width set on box A, otherwise its inner content will collapse to width of 0
    const leftWidthMin = 60;

    // Resize box A
    // * 8px is the left/right spacing between .handler and its inner pseudo-element
    // * Set flex-grow to 0 to prevent it from growing
    this.leftPane.style.width = `${Math.max(leftWidthMin, pointerRelativeXpos - 8)}px`;
    this.leftPane.style.flexGrow = "0";
  }

  onMouseUp(e: MouseEvent) {
    this.removeListeners();
  }

  destroyed() {
    this.removeListeners();
  }

  removeListeners() {
    document.removeEventListener("mousemove", this.onMouseMove);
    document.removeEventListener("mouseup", this.onMouseUp);

    this.rightPane.style.pointerEvents = this.pointerEvents;
  }
}

export default makeHook(DraggableGutter);
