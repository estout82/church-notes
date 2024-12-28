import { Controller } from "@hotwired/stimulus";
import { getLocalISOString } from "../lib/date_helper";
import * as lodash from "lodash";

export default class extends Controller {
  static targets = ["hour", "minute", "ampm", "hidden"]

  connect() {
    if (this.hiddenTarget.value) {
      const date = new Date(this.hiddenTarget.value);
      let hours = date.getHours();
      let minutes = date.getMinutes();

      if (hours > 12) {
        hours = hours - 12;
        this.ampmTarget.value = "pm";

      } else {
        this.ampmTarget.value = "am";

      }

      if (minutes.toString().length < 2) {
        minutes = "0" + minutes;
      }

      this.hourTarget.value = hours;
      this.minuteTarget.value = minutes;
      this.state = {lastHourValue: hours, lastMinuteValue: minutes};

    } else {
      this.state = {lastHourValue: "", lastMinuteValue: ""};

    }
  }

  /**
   * actions
   */

  change() {
    let hour = this.hourTarget.value;
    let minute = this.minuteTarget.value;

    if (hour != "") {
      if (!this.isNumericOrBlank(hour) || hour > 12 || hour < 1) {
        this.hourTarget.value = this.state.lastHourValue;
        return;
      }
    }

    if (minute != "") {
      if (!this.isNumericOrBlank(minute) || minute > 59 || minute < 0) {
        this.minuteTarget.value = this.state.lastMinuteValue;
        return;
      }
    }

    if (this.ampmTarget.value == "pm") {
      hour = lodash.toInteger(hour) + 12;
    }

    let date = new Date();

    date.setHours(hour);
    date.setMinutes(minute);
    date.setSeconds(0);
    date.setMilliseconds(0);

    const dateString = getLocalISOString(date);
    this.hiddenTarget.value = dateString;

    this.state.lastHourValue = hour;
    this.state.lastMinuteValue = minute;
  }

  /**
   * helpers
   */

  isValidHour(hour) {
    lodash.isNumber(hour) && hour <= 12 && hour >= 1
  }

  isValidMinute() {

  }

  isNumericOrBlank(string) {
    if (string == "")
      return true;

    return string.match(/^[0-9]+$/) != null;
  }
}
