
export function extractFillInValues(contentElement: HTMLElement) {
  let values = [];

  contentElement.querySelectorAll(".cdx-fill-in").forEach(element => {;
    values.push({id: "", value: element.textContent});
  });

  return values;
}
