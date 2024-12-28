/**
 * Allows creation of toast messages from the client
 */

function error(message) {
  createMessage(message, "error");
}

function info(message) {
  createMessage(message, "info");
}

function createMessage(message, color) {
  const element = document.createElement("div");
  element.className = `bg-${color} mt-8 p-4 rounded shadow-lg`;
  element.setAttribute("data-toast-target", "message");

  element.innerHTML = `
    <p class="text-fill">
      ${message}
    </p>
  `;

  document.getElementById("flash").appendChild(element);
}

export default {
  error,
  info
};