/**
 * Client side behavior to prepare a note to be emailed
 */

import {Controller} from "@hotwired/stimulus";
import {extractFillInValues} from "../../../lib/note_helper";

export default class extends Controller {
  static targets = ["fillInValues"];

  declare readonly fillInValuesTarget: HTMLInputElement;

  submit(event: SubmitEvent) {
    const values = extractFillInValues(this.noteContentElement);
    this.fillInValuesTarget.value = JSON.stringify(values);
  }

  get noteContentElement() {
    return document.querySelector("[data-external--note-target='content']") as HTMLElement;
  }
}
