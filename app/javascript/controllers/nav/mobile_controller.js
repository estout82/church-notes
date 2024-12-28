import {Controller} from "@hotwired/stimulus";
import {enter, leave} from "el-transition";

export default class extends Controller {
  static targets = ["panel", "bars", "x"];

  /**
   * lifecycle
   */

  connect() {
    document.addEventListener("click", (e) => {
      const path = e.composedPath();

      if (!path.includes(this.element)) {
        this.close();
      }
    });
  }
  
  /**
   * actions
   */

  toggle() {
    if (this.panelTarget.classList.contains("hidden")) {
      this.open();
    } else {
      this.close();
    }
  }

  /**
   * helpers
   */

  open() {
    enter(this.panelTarget);

    this.barsTarget.classList.toggle("hidden", true);
    this.xTarget.classList.toggle("hidden", false);
  }

  close() {
    leave(this.panelTarget);

    this.barsTarget.classList.toggle("hidden", false);
    this.xTarget.classList.toggle("hidden", true);
  }
}
