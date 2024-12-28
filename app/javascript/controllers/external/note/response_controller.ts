import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  connect(): void {
    this.element.setAttribute("data-shown", "false");
  }

  close() {
    this.element.setAttribute("data-shown", "false");
  }

  open() {
    this.element.setAttribute("data-shown", "true");
  }
}