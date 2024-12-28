/**
 * Client side behavior for toggle controls
 */

import {Controller} from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["button", "background"];

  /**
   * actions
   */

  async toggle() {
    const newEnabled = !this.enabled();

    this.slide(newEnabled);
    this.backgroundTarget.setAttribute("data-checked", newEnabled.toString());

    if (this.hasPostToggleRequest()) {
      const res = await fetch(this.getEndpoint(), {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": Rails.csrfToken(),
          "Content-Type": "application/json",
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: this.getPayload()
      });

      if (!res.ok) {
        this.slide(!newEnabled);
      } else {
        const newPayload = JSON.parse(this.getPayload());
        const outerKey = Object.keys(newPayload).at(0);
        const innerKey = Object.keys(newPayload[outerKey]).at(0);
        newPayload[outerKey][innerKey] = newEnabled;

        this.element.setAttribute("data-payload", JSON.stringify(newPayload));
      }

      Turbo.renderStreamMessage(await res.text());
    }
  }

  /**
   * helpers
   */

  slide(enabled) {
    if (enabled) {
      this.backgroundTarget.classList.toggle("bg-primary", true);
      this.backgroundTarget.classList.toggle("bg-input", false);
      this.buttonTarget.classList.toggle("translate-x-5", true);
      this.buttonTarget.classList.toggle("translate-x-0", false);
    } else {
      this.backgroundTarget.classList.toggle("bg-primary", false);
      this.backgroundTarget.classList.toggle("bg-input", true);
      this.buttonTarget.classList.toggle("translate-x-5", false);
      this.buttonTarget.classList.toggle("translate-x-0", true);
    }
  }

  enabled() {
    return this.backgroundTarget.getAttribute("data-checked") == "true";
  }

  hasPostToggleRequest() {
    return this.getPayload() && this.getEndpoint();
  }

  getPayload() {
    return this.element.getAttribute("data-payload");
  }

  getEndpoint() {
    return this.element.getAttribute("data-endpoint");
  }
}
