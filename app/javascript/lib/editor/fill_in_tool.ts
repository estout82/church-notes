/**
 * Editor JS plugin for fill in the blanks
 */

export default class FillInTool {
  button: HTMLButtonElement | null;
  _state: boolean;
  api: any; // Injected from the editorjs library
  tag: string;
  class: string;

  static get isInline() {
    return true;
  }

  static get shortcut() {
    return "CMD+F";
  }

  get state() {
    return this._state;
  }

  static get title() {
    return "Fill-in";
  }

  static get sanitize() {
    return {
      mark: {
        class: "cdx-fill-in"
      }
    };
  }

  set state(state) {
    this._state = state;
    this.button?.classList.toggle(this.api.styles.inlineToolButtonActive, state);
  }

  constructor({api}) {
    this.api = api;
    this.button = null;
    this._state = false;
    this.tag = 'MARK';
    this.class = 'cdx-fill-in';
  }

  render() {
    this.button = document.createElement('button');
    this.button.type = 'button';
    this.button.innerHTML = `<svg id="Layer_1" xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" viewBox="0 0 138 138"><defs><style>.cls-1{stroke:#666;}.cls-1,.cls-2{fill:none;stroke-miterlimit:10;stroke-width:2px;}.cls-2{stroke:#000;}</style></defs><line class="cls-1" x1="36.5551" y1="41.8792" x2="101.5551" y2="41.8792"/><line class="cls-1" x1="36.4449" y1="96.1208" x2="101.4449" y2="96.1208"/><line class="cls-1" x1="36.5551" y1="51.8792" x2="81.5551" y2="51.8792"/><line class="cls-1" x1="36.5551" y1="61.8792" x2="91.5551" y2="61.8792"/><line class="cls-1" x1="36.4449" y1="86.1208" x2="91.4449" y2="86.1208"/><line class="cls-1" x1="81.4449" y1="74.1208" x2="96.4449" y2="74.1208"/><rect class="cls-2" x="36.4449" y="69.1208" width="40.5" height="8"/></svg>`;

    return this.button;
  }

  surround(range) {
    if (this.state) {
      this.unwrap(range);
      return;
    }

    this.wrap(range);
  }

  wrap(range) {
    const selectedText = range.extractContents();
    const mark = document.createElement(this.tag);

    mark.className = this.class;
    mark.appendChild(selectedText);
    range.insertNode(mark);

    this.api.selection.expandToTag(mark);
  }

  unwrap(range) {
    const mark = this.api.selection.findParentTag(this.tag, this.class);
    const text = range.extractContents();

    mark.remove();

    range.insertNode(text);
  }

  checkState() {
    const mark = this.api.selection.findParentTag(this.tag);
    this.state = !!mark;
  }
}
