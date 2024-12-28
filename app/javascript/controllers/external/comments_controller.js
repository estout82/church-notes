/**
 * Controls the comments on external notes
 */

import { Controller } from "@hotwired/stimulus";
import { enter, leave } from "el-transition";

export default class extends Controller {
  static targets = ["overlay"];

  /**
   * actions
   */

  open() {
    enter(this.overlayTarget).then(() => this.overlayTarget.classList.toggle("left-0", true));
    document.body.classList.toggle("overflow-hidden", true);
  }

  close() {
    leave(this.overlayTarget);
    document.body.classList.toggle("overflow-hidden", false);
  }
}
