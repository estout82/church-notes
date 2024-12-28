import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";
import {debounce} from "lodash";

export default class extends Controller {
  static targets = ["value", "hidden", "input", "panel", "results"];

  /**
   * lifecycle
   */

  connect() {
    this.search = debounce(this.doSearch, 200);

    document.addEventListener("click", event => {
      const path = event.composedPath();

      if (!path.includes(this.panelTarget) &&
          !path.includes(this.valueTarget))
        this.closePanel();
    });
  }

  /**
   * actions
   */

  open(event) {
    event.preventDefault();
    event.stopPropagation();
    this.openPanel();
    this.doSearch();
  }

  /**
   * helper methods
   */

  doSearch() {
    const query = this.inputTarget.value;

    this.handleLoading();

    fetch(`/notes/search?query=${query}`, {
      method: "GET",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Accept": "application/json"
      }
    }).then(res => {
      if (res.ok) {
        return res.json();
      }

      return Promise.reject();

    }).then(data => {
      this.handleSearchResults(data);

    }).catch(res => {
      console.error(res);
    });
  }

  handleLoading() {
    this.resultsTarget.innerHTML = "Loading...";
  }

  handleSearchResults(data) {
    let elements = [];

    if (data.length > 0) {
      data.forEach(note => {
        elements.push(this.createNoteElement(note));
      });
    } else {
      let elem = document.createElement("p");
      elem.innerText = "No results";

      elements.push(elem);
    }

    this.resultsTarget.innerHTML = "";

    for (let elem of elements)
      this.resultsTarget.appendChild(elem);
  }

  createNoteElement(note) {
    let elem = document.createElement("button");
    elem.setAttribute("data-note-id", note.id);
    elem.innerText = note.title;
    elem.className = "px-2 py-1 block hover:text-primary hover:cursor-pointer";

    elem.addEventListener("click", this.handleResultClick.bind(this));

    return elem;
  }

  handleResultClick(e) {
    e.preventDefault();

    const elem = e.currentTarget;
    const noteId = elem.getAttribute("data-note-id");
    const noteTitle = elem.innerText;

    this.valueTarget.innerText = noteTitle;
    this.hiddenTarget.value = noteId;

    this.closePanel();
  }

  openPanel() {
    this.panelTarget.classList.toggle("hidden", false);
    this.panelTarget.setAttribute("data-open", "true");
  }

  closePanel() {
    this.panelTarget.classList.toggle("hidden", true);
    this.inputTarget.value = "";
    this.resultsTarget.innerHTML = "";
    this.panelTarget.setAttribute("data-open", "false");
  }
}
