import {Controller} from "@hotwired/stimulus";
import {enter, leave} from "el-transition";
import Rails from "@rails/ujs";
import lodash from "lodash";

export default class extends Controller {
  static targets = ["editor", "icons", "drag"];
  
  static values = {id: Number};

  /**
   * lifecycle
   */

  connect() {
    this.submitSaveDebounced = lodash.debounce(this.submitSave.bind(this), 200);
  }

  /**
   * actions
   */

  mouseEnter() {
    enter(this.iconsTarget);
  }

  mouseLeave() {
    leave(this.iconsTarget);
  }

  save(e) {
    const value = e.target.innerText;
    this.submitSaveDebounced(value);
  }

  bold() {
    document.execCommand("bold", true, true);
  }

  /**
   * helpers
   */

  submitSave(value) {
    const blockId = this.idValue;

    fetch(`/blocks/${blockId}`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify({
        block: {
          content: value
        }
      })
    })
    .then((res) => {
      if (res.status >= 300) {
        console.error(res);
      }
    })
    .catch((res) => {
      console.error(res);
    });
  }
}
