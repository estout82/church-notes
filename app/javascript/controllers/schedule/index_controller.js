import {Controller} from "@hotwired/stimulus";
import {enter, leave} from "el-transition";

export default class extends Controller {
  static targets = ["editFrame", "scheduleNoteButton"]

  /**
   * actions
   */

  showScheduleNoteButton(e) {
    const cell = e.currentTarget;
    const scheduleButton = cell.querySelector("button[data-application-target='modalButton']");

    enter(scheduleButton);
  }

  hideScheduleNoteButton(e) {
    const cell = e.currentTarget;
    const scheduleButton = cell.querySelector("button[data-application-target='modalButton']");

    leave(scheduleButton);
  }

  showEdit(e) {
    const element = e.currentTarget;
    const scheduleId = element.getAttribute("data-schedule-id");

    this.editFrameTarget.src = `/schedules/${scheduleId}/edit`;
    this.editFrameTarget.reload();
  }
}