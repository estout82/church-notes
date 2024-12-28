/**
 * Client side behavior for the external nav
 */

import {Controller} from "@hotwired/stimulus";
import {enter, leave} from "el-transition";
import ToastHelper from "../../lib/toast_helper";

export default class extends Controller {
  static targets = ["overlay", "login"];

  /**
   * actions
   */

  open() {
    enter(this.overlayTarget);
    document.body.classList.toggle("overflow-hidden", true);
  }

  close() {
    leave(this.overlayTarget);
    document.body.classList.toggle("overflow-hidden", false);
  }

  highlightLoginButton(event) {
    const message = event.target.dataset.message;

    ToastHelper.info(message);

    const doHighlight = () => {
      this.highlightLoginButtonAppearance();
      setTimeout(() => this.unhighlightLoginButtonAppearance(), 3000);
    };

    if (!this.overlayIsOpen) {
      enter(this.overlayTarget).then(() => {
        doHighlight();  
      });
    } else {
      doHighlight();
    }
  }

  /**
   * helpers
   */

  overlayIsOpen() {
    return !this.overlayTarget.classList.contains("hidden");
  }

  highlightLoginButtonAppearance() {
    this.loginTarget.classList.toggle("border-4", true);
    this.loginTarget.classList.toggle("border-fill", true);
    this.loginTarget.classList.toggle("transform", true);
    this.loginTarget.classList.toggle("scale-110", true);
  }

  unhighlightLoginButtonAppearance() {
    this.loginTarget.classList.toggle("border-4", false);
    this.loginTarget.classList.toggle("border-fill", false);
    this.loginTarget.classList.toggle("transform", false);
    this.loginTarget.classList.toggle("scale-110", false);
  }
}
