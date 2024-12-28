/**
 * Client side behavior to prepare a note to be downloaded
 */

import {Controller} from "@hotwired/stimulus";
import {extractFillInValues} from "../../../lib/note_helper";

export default class extends Controller {
  static values = {
    noteAltId: String
  };

  declare readonly noteAltIdValue: string;

  /**
   * actions
   */

  download() {
    const values = extractFillInValues(this.noteContentElement);
    const json = JSON.stringify(values);

    const url = `/external/notes/${this.noteAltIdValue}/downloads/new?fill_in_values=${encodeURIComponent(json)}`;

    Turbo.visit(url);
  }

  get noteContentElement() {
    return document.querySelector("[data-external--note-target='content']") as HTMLElement;
  }
}
