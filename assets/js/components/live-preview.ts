export class LivePreview extends HTMLElement {
  constructor() {
    super();

    this.attachShadow({ mode: "open" });
  }

  public set content(content: string) {
    if (this.shadowRoot) {
      this.shadowRoot.innerHTML = content;
    }
  }
}

customElements.define("live-preview", LivePreview);
