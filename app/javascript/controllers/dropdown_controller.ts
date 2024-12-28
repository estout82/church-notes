import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selection", "panel"];

  declare panelTarget: HTMLElement | undefined;
  declare selectionTarget: HTMLElement | undefined;

  toggle(event: MouseEvent) {
    if (this.isOpen())
      this.close();
    else
      this.open();
  }

  handleDocumentClick(event) {
    const path = event.composedPath();

    if (!path.includes(this.panelTarget) &&
      !path.includes(this.selectionTarget) &&
      this.isOpen()) {
      this.close();
    }
  }

  open() {
    let panel = this.panelTarget;
    panel?.classList.remove("hidden");
  }

  close() {
    let panel = this.panelTarget;
    panel?.classList.add("hidden");
  }

  isOpen() {
    let panel = this.panelTarget;
    return !panel?.classList.contains("hidden");
  }
}
