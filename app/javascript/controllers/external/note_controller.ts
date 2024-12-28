import {Controller} from "@hotwired/stimulus";
import Api from "../../lib/api";

export default class extends Controller {
  static targets = ["content"];

  static values = {
    fillInValues: Object,
    noteInstanceId: Number
  };

  declare readonly contentTarget: HTMLElement;
  declare readonly fillInValuesValue: Object;
  declare readonly noteInstanceIdValue: number;

  connect() {
    this.prepareFillIns();
    setTimeout(() => this.show());
  }

  // Replaces the editor fill-ins with fill-in the blank contenteditables
  prepareFillIns() {
    this.contentTarget.querySelectorAll(".cdx-fill-in").forEach((fillInElement, index) => {
      const container = document.createElement("span");
      container.classList.toggle("pr-8", true);
      container.classList.toggle("pl-2", true);
      container.classList.toggle("rounded", true);
      container.classList.toggle("bg-gray-100", true);
      container.classList.toggle("border", true);
      container.classList.toggle("border-gray", true);
      container.classList.toggle("inline-block", true);
      container.classList.toggle("fill-in-replaced", true);
      container.classList.toggle("relative", true);

      const element = fillInElement as HTMLElement;
      const answer = element.innerText;

      element.classList.toggle("align-middle", true);
      element.setAttribute("style", `min-width: ${answer.length + 5}ch`);
      element.setAttribute("contenteditable", "true");
      element.innerHTML = this.fillInValuesValue[index] || "";

      if (this.noteInstanceIdValue) {
        element.addEventListener("input", () => {
          const value = element.textContent;

          Api.NoteInstances.updateFillInValue({
            noteInstanceId: this.noteInstanceIdValue,
            index,
            value
          })
        });
      }

      const revealButton = document.createElement("button");
      revealButton.setAttribute("class", "text-2xl inline align-middle ml-2 hover:opacity-70 transform hover:scale-110 transition duration-100 absolute right-1 top-0 h-full flex items-center");
      revealButton.textContent = "👀";

      element.before(container);
      element.remove();
      container.append(element);
      container.append(revealButton);

      revealButton.addEventListener("click", () => {
        element.innerText = answer;
      });
    });
  }
  
  show() {
    this.contentTarget.removeAttribute("loading-state");
  }
}
