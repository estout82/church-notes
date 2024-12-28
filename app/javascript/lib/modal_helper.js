/**
 * Module that controls modal behavior
 */

function open(id) {
  const modal = document.getElementById(id);
  modal.classList.toggle("hidden", false);
  pushModalId(id);
}

function close(id = null, options = {resetFrames: null}) {
  const {resetFrames} = options;

  if (!id)
    id = popModalId();

  const modal = document.getElementById(id);

  if (modal) {
    if (resetFrames) {
      const frames = modal.querySelectorAll("turbo-frame");

      frames.forEach(frame => {
        frame.reload();
      });
    }

    modal.classList.toggle("hidden", true);
  }

  popModalId({save: true});
}

function shouldClose(event) {
  const openModalId = popModalId();

  if (openModalId) {
    const path = event.composedPath();
    let modal = document.getElementById(openModalId);
    const panel = modal.querySelector("[data-modal-role='panel']");

    if (!path.includes(panel))
      return true;
  }

  return false;
}

function isModalOpen() {
  /**
   * Returns true if there are any open modals
   */

  return document
    .body
    .getAttribute("data-open-modal-id")
    .length > 0;
}

/**
 * helpers
 */

function pushModalId(id) {
  const openModals = document
    .body
    .getAttribute("data-open-modal-id")
    .split(" ");
  
  openModals.push(id);

  document.body.setAttribute(
    "data-open-modal-id",
    openModals.join(" ")
  );
}

function popModalId(options = {save: false}) {
  const {save} = options;

  const poppedModalId = document
    .body
    .getAttribute("data-open-modal-id")
    .split(" ")
    .filter(value => value != "")
    .pop();

  if (save) {
    const value = document
      .body
      .getAttribute("data-open-modal-id")
      .split(" ")
      .filter(value => value != "");

    value.pop();

    document
      .body
      .setAttribute(
        "data-open-modal-id",
        value.join(" ")
      );
  }

  return poppedModalId;
}

export default {
  open,
  close,
  shouldClose,
  isModalOpen
};