import {Controller} from "@hotwired/stimulus";
import moment from "moment-timezone";
import Api from "../lib/api";
import ModalHelper from "../lib/modal_helper";

export default class extends Controller {
  static targets = [
    "modalButton",
    "panel",
    "preventDefault",
    "closeModal",
    "closeAllModals"
  ];

  /**
   * lifecycle
   */

  connect() {
    /**
     * Make sure that client time-zone is the same as stored timezone on server. If time zone
     * is different, update user's time zone via DB.
     */

    const currentUserTimeZone = this.element.getAttribute("data-user-time-zone");
    const clientTimeZone = moment.tz.guess();

    if (currentUserTimeZone != clientTimeZone && currentUserTimeZone != null) {
      console.error(`client timezone does not match stored time zone. changing from ${currentUserTimeZone} to ${clientTimeZone}`);

      try {
        Api.CurrentUser.updateTimeZone(clientTimeZone);  
      } catch (error) {
        console.error("unable to update timezone");
      }
    }

    /**
     * Handle close on click-off for modals
     */

    document.addEventListener("click", event => {
      if (ModalHelper.shouldClose(event))
        ModalHelper.close();
    });
  }

  modalButtonTargetConnected(button) {
    button.addEventListener("click", event => {
      const modalId = button.getAttribute("data-modal-id");
      const modalAction = button.getAttribute("data-modal-action");

      if (modalId && modalAction == "open") {
        ModalHelper.open(modalId);
      } else if (modalId && modalAction == "close") {
        ModalHelper.close(modalId);
      }

      event.stopPropagation();
      event.preventDefault();
    });
  }

  preventDefaultTargetConnected(element) {
    element.addEventListener("click", e => {
      e.preventDefault();
    });
  }

  closeModalTargetConnected() {
    /**
     * Some turbo stream responses include a div with this target that
     * forces closed the top open modals.
     */

    ModalHelper.close(null, {resetFrames: true});
  }

  closeAllModalsTargetConnected() {
    /**
     * Some turbo stream responses include a div with this target that
     * forces closed the ALL open modals.
     */

    while (ModalHelper.isModalOpen()) {
      ModalHelper.close();
    }
  }

  refreshPageTargetConnected() {
    location.reload();
  }
}
