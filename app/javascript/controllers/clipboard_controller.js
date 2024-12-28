
import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  copy() {
    const startText = this.element.getAttribute("data-start-text");
    const text = this.element.getAttribute("data-text");

    navigator.clipboard.writeText(text)
      .then(() => {
        this.element.innerText = "Copied!";

        if (this.lastCopyButtonTimeout) {
          clearTimeout(this.lastCopyButtonTimeout);
        }

        this.lastCopyButtonTimeout = setTimeout(() => {
          this.element.innerText = startText;
        }, 2000);
      })
      .catch(error => {
        console.error(`unable to copy invitation link to clipboard: ${error}`);
        
        this.element.innerText = "Error!";

        if (this.lastCopyButtonTimeout) {
          clearTimeout(this.lastCopyButtonTimeout);
        }

        this.lastCopyButtonTimeout = setTimeout(() => {
          this.element.innerText = "Error!";
        }, 2000);
      });
  }
}