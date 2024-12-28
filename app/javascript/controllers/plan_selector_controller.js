import { Controller } from "@hotwired/stimulus"

const TEST_STRIPE_IDS = {
  FREE: "price_1KBca4KagyQ1cx20qn7nY1QR",
  BASE: "price_1KBcaEKagyQ1cx20Ni1YABnD",
  MULTISITE: "price_1KBcaQKagyQ1cx20rKT8OnlR",
  MULTISITE_SUBACCOUNT: "price_1KBcagKagyQ1cx20qRAeF5Qv"
}

const STRIPE_IDS = TEST_STRIPE_IDS;

function select(elem) {
  // remove unselected classes
  elem.classList.remove("hover:bg-secondary");
  elem.classList.remove("hover:cursor-pointer");

  // add selected classes
  elem.classList.add("bg-primary");
  elem.classList.add("text-fill");
}

function unselect(elem) {
  // remove selected classes
  elem.classList.remove("bg-primary");
  elem.classList.remove("text-fill");

  // add unselected classes
  elem.classList.add("hover:bg-secondary");
  elem.classList.add("hover:cursor-pointer");
}

export default class extends Controller {
  static targets = [ "free", "base", "multisite", "value", "subaccounts", "subAccountPicker", "subAccountInput" ]

  selectFree() {
    let value = STRIPE_IDS.FREE;
    let target = this.valueTarget;
    target.value = value;

    select(this.freeTarget);
    unselect(this.baseTarget);
    unselect(this.multisiteTarget);

    this.subAccountPickerTarget.classList.add("hidden");
  }

  selectBase() {
    let value = STRIPE_IDS.BASE;
    let target = this.valueTarget;
    target.value = value;

    unselect(this.freeTarget);
    select(this.baseTarget);
    unselect(this.multisiteTarget);

    this.subAccountPickerTarget.classList.add("hidden");
  }

  selectMultisite() {
    let value = STRIPE_IDS.MULTISITE;
    let target = this.valueTarget;
    target.value = value;

    unselect(this.freeTarget);
    unselect(this.baseTarget);
    select(this.multisiteTarget);

    this.subAccountPickerTarget.classList.remove("hidden");
  }

  addSubAccount(e) {
    e.preventDefault(); // prevent form submission

    let accountName = this.subAccountInputTarget.value; // TODO: need to sanitize this...
    this.subAccountInputTarget.value = "";

    let container = document.createElement("div");
    container.classList.add("m-2");

    container.innerHTML = `
      <input type="hidden" name="subaccounts[]" value="${accountName}" />
      <span class="font-bold">${accountName}</span>
      <button class="ml-1 font-bold text-error transition transition-duration-300 transform hover:scale-110" data-action="click->plan-selector#removeSubAccount">x</button>
    `;

    this.subaccountsTarget.append(container);
  }

  removeSubAccount(e) {
    e.preventDefault(); // prevent form submission

    let currentTarget = e.currentTarget;
    currentTarget.parentElement.remove();
  }
}
