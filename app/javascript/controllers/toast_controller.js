import {Controller} from "@hotwired/stimulus";
import {enter, leave} from "el-transition";

export default class extends Controller {
  static targets = ["message"];

  messageTargetConnected(element) {
    enter(element);

    setTimeout(() => {
      leave(element);
    }, 5000);
  }

  dismiss(event) {
    leave(event.target);
  }
}
