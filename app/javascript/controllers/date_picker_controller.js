import {Controller} from "@hotwired/stimulus";
import {getLocalISOString} from "../lib/date_helper";

export default class extends Controller {
  static targets = [
    "value",
    "panel",
    "days",
    "panelLabel",
    "hidden"
  ];

  connect() {
    if (this.hiddenTarget.value) {
      const value = this.hiddenTarget.value;

      this.state = {
        current: new Date(value),
        selected: new Date(value)
      };

    } else {
      this.state = {
        current: new Date(),
        selected: null
      };

    }

    this.render();

    // add a click listener to document that closes the panel
    document.addEventListener("click", event => {
      const path = event.composedPath();

      if (!path.includes(this.element)) {
        this.closePanel();
      }
    });
  }

  /**
   * actions
   */

  open(event) {
    event.preventDefault();

    this.openPanel();
    this.render();
  }

  select(event) {
    event.preventDefault();

    const elem = event.currentTarget;

    const date = elem.getAttribute("data-date");
    const newSelected = new Date(this.state.current);
    newSelected.setDate(date);

    this.state.selected = newSelected;
    this.hiddenTarget.value = getLocalISOString(this.state.selected);

    this.render();
    this.closePanel();
  }

  prevMonth(event) {
    event.preventDefault();

    if (this.state.current.getMonth() == 0) {
      this.state.current.setFullYear(
        this.state.current.getFullYear() - 1
      );

      this.state.current.setMonth(11);
    } else {
      this.state.current.setMonth(
        this.state.current.getMonth() - 1
      );

    }

    this.render();
  }

  nextMonth(event) {
    event.preventDefault();

    if (this.state.current.getMonth() == 11) {
      this.state.current.setFullYear(
        this.state.current.getFullYear() + 1
      );

      this.state.current.setMonth(0);

    } else {
      this.state.current.setMonth(
        this.state.current.getMonth() + 1
      );

    }

    this.render();
  }

  /**
   * helpers
   */

  render() {
    // render the value
    if (this.state.selected) {
      const selectedValueText = Intl.DateTimeFormat(
        "en-US", 
        {
          month: "long",
          day: "numeric",
          year: "numeric"
        }
      ).format(this.state.selected);
  
      this.valueTarget.innerText = selectedValueText;

    } else {
      this.valueTarget.innerText = "";

    }

    // clear out days' children to start
    while (this.daysTarget.firstChild) {
      this.daysTarget.removeChild(this.daysTarget.firstChild);

    }

    // fill in the empty spots
    this.state.current.setDate(1);
    const dayOfWeekStart = this.state.current.getDay();

    for (let i = 0; i < dayOfWeekStart; i++) {
      const placeholderElem = document.createElement("div");
      placeholderElem.append(document.createTextNode(""));
      this.daysTarget.append(placeholderElem);
    
    }

    // fill in days
    const CONSTANT = 40;

    let currentDateCopy = new Date(this.state.current);
    currentDateCopy.setDate(CONSTANT);

    const daysInMonth = CONSTANT - currentDateCopy.getDate();

    for (let i = 0; i < daysInMonth; i++) {
      let dayDate = new Date(this.state.current);
      dayDate.setDate(i + 1);

      const dayElem = document.createElement("div");

      dayElem.className = `
        m-1 text-muted font-bold text-center
        rounded hover:cursor-pointer hover:bg-input
      `;

      dayElem.appendChild(document.createTextNode(i + 1));
      dayElem.setAttribute("data-date",  i + 1);

      dayElem.setAttribute(
        "data-action",
        "click->date-picker#select"
      );

      if (this.compareDate(this.state.selected, dayDate)) {
        dayElem.className = `
          m-1 text-fill font-bold text-center
          rounded bg-primary
        `;
      }

      this.daysTarget.append(dayElem);
    }

    // fill in extra spaces
    const mod = this.daysTarget.children.length % 7;

    for (let i = 0; i < 7 - mod; i++) {
      const placeholderElem = document.createElement("div");
      placeholderElem.append(document.createTextNode(""));
      this.daysTarget.append(placeholderElem);
    }

    // render panel label
    const monthText = Intl.DateTimeFormat("en-US", { month: "long" }).format(this.state.current);
    this.panelLabelTarget.innerText = `${monthText} ${this.state.current.getFullYear()}`;
  }

  compareDate(dateOne, dateTwo) {
    return dateOne && dateTwo &&
      dateOne.getDate() === dateTwo.getDate() &&
      dateOne.getMonth() === dateTwo.getMonth() &&
      dateOne.getYear() === dateTwo.getYear();
  }

  openPanel() {
    this.panelTarget.classList.toggle("hidden", false);
    this.panelTarget.setAttribute("data-open", "true");
  }

  closePanel() {
    this.panelTarget.classList.toggle("hidden", true);
    //this.inputTarget.value = "";
    //this.resultsTarget.innerHTML = "";
    this.panelTarget.setAttribute("data-open", "false");
  }
}