import {Controller} from "@hotwired/stimulus";
import Rails from "@rails/ujs";
import ToastHelper from "../../lib/toast_helper";

export default class extends Controller {
  static targets = ["savedMessage", "primaryNoteSavedMessage"];

  /**
   * actions
   */

  submitRedirectValue(event) {
    const checkbox = event.target;
    const value = checkbox.checked;
    const accountId = this.element.getAttribute("data-account-id");

    fetch(`/accounts/${accountId}/update_link_redirects`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Content-Type": "application/json",
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({
        account: {
          link_redirects: value
        }
      })
    }).then(res => {
      if (res.ok) {
        this.showSavedMessage();
        res.text().then(html => Turbo.renderStreamMessage(html));
        return;
      }

      ToastHelper.error("Sorry, we weren't able to save that");

    }).catch(error => {
      ToastHelper.error("Sorry, we weren't able to save that");
    });
  }

  submitPrimaryNoteValue(event) {
    const selectBox = event.target;
    const value = selectBox.value;
    const accountId = this.element.getAttribute("data-account-id");

    fetch(`/accounts/${accountId}/primary_note`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Content-Type": "application/json",
        "Accept": "text/vnd.turbo-stream.html"
      },
      body: JSON.stringify({
        account: {
          primary_note_id: value
        }
      })
    }).then(res => {
      if (res.ok) {
        this.showPrimaryNoteSavedMessage();
        res.text().then(html => Turbo.renderStreamMessage(html));
        return;
      }

      ToastHelper.error("Sorry, we weren't able to save that");

    }).catch(error => {
      ToastHelper.error("Sorry, we weren't able to save that");
    });
  }

  /**
   * helpers
   */

  showSavedMessage() {
    if (this.lastTimeout)
      clearTimeout(this.lastTimeout);

    this.savedMessageTarget.classList.toggle("hidden", false);

    this.lastTimeout = setTimeout(() => {
      this.savedMessageTarget.classList.toggle("hidden", true);
    }, 3000);
  }

  showPrimaryNoteSavedMessage() {
    if (this.lastPrimaryNoteTimeout)
      clearTimeout(this.lastPrimaryNoteTimeout);

    this.primaryNoteSavedMessageTarget.classList.toggle("hidden", false);

    this.lastPrimaryNoteTimeout = setTimeout(() => {
      this.primaryNoteSavedMessageTarget.classList.toggle("hidden", true);
    }, 3000);
  }

  updateRedirectingTag(primaryNoteId) {
    document.querySelectorAll(".external-note").forEach(noteElem => {
      const noteId = noteElem.getAttribute("data-note-id");
      noteElem.querySelector(".note-redirect-indicator").classList.toggle("hidden", noteId != primaryNoteId);
    });
  }
}