
import React from "react";
import ReactDOM from "react-dom";

// a window load event will not work because of turbo frames
// - the window is only loaded on a hard-refresh, otherwise new pages are fetched with xhr

export function renderComponent(Component, rootId) {
  // attempt to render every 10 ms
  const interval = setInterval(() => {
    let rootElem = document.getElementById(rootId);
  
    if (rootElem) {
      doRender(rootElem);
    }
  }, 10);

  function doRender(elem) {
    ReactDOM.render(Component, elem);
    clearInterval(interval);
  }
}