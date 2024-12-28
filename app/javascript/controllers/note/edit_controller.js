import {Controller} from "@hotwired/stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [
    "backgroundColorSwatch",
    "submitUnsplashSearch",
    "noteLink",
    "livePreview",
    "refreshLivePreview"
  ];

  static values = {
    noteId: String
  };

  /**
   * lifecycle
   */

  refreshLivePreviewTargetConnected() {
    /**
     * Some turbo stream responses return an element with data-note--edit-target="refreshLivePreview"
     * which allows this controller to refresh the live preview when something of note happens on the controller
     * eg. another user edits or the banner changed
     */

    this.refreshLivePreview();
  }

  /**
   * actions
   */

  handleTitleChange(event) {
    const value = event.target.value;

    fetch(`/notes/${this.noteIdValue}?field=title`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Accept": "text/vnd.turbo-stream.html",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        note: {
          title: value
        }
      })
    }).then(res => {

      if (res.ok) {
        // TODO add a 'Saved' label under control

        return;
      }

    }).catch(error => {
      console.error("an error occurred while saving title");
      console.error(error);
    });
  }

  handleSharingChange(event) {
    const value = event.target.value;

    fetch(`/notes/${this.noteIdValue}?field=sharing`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Accept": "text/vnd.turbo-stream.html",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        note: {
          sharing: value
        }
      })
    }).then(res => {

      if (res.ok) {
        // TODO add a 'Saved' label under control
        return;
      }

    }).catch(error => {
      console.error("an error occurred while saving sharing");
      console.error(error);
    });
  }

  unsplashSearch() {
    this.submitUnsplashSearchTarget.click();
  }

  contentChange() {
    /**
     * Fired by the note editor React component when the note content changes.
     */

    this.refreshLivePreview();
  }
  
  copyNoteLink(e) {
    const link = this.noteLinkTarget.innerText.trim();
    const button = e.target;

    navigator.clipboard.writeText(link)
      .then(() => {
        button.innerText = "Copied!";

        if (this.lastCopyButtonTimeout) {
          clearTimeout(this.lastCopyButtonTimeout);
        }

        this.lastCopyButtonTimeout = setTimeout(() => {
          button.innerText = "Copy";
        }, 2000);
      })
      .catch(error => {
        console.error(`unable to copy invitation link to clipboard: ${error}`);
        
        button.innerText = "Error!";

        if (this.lastCopyButtonTimeout) {
          clearTimeout(this.lastCopyButtonTimeout);
        }

        this.lastCopyButtonTimeout = setTimeout(() => {
          button.innerText = "Error!";
        }, 2000);
      });
  }

  /**
   * helpers
   */

  refreshLivePreview() {
    const src = this.livePreviewTarget.src;

    this.livePreviewTarget.src = "";
    this.livePreviewTarget.src = src;
  }
}
