/**
 * Wrapper for editor.js
 */

import { Controller } from "@hotwired/stimulus";
import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header"; 
import NestedList from "@editorjs/nested-list";
import Quote from "@editorjs/quote";
import Table from "@editorjs/table";
import Paragraph from "@editorjs/paragraph";
import lodash from "lodash";
import api from "../../lib/api";
import FillInTool from "../../lib/editor/fill_in_tool";

export default class extends Controller {
  static values = {
    noteId: String
  };

  declare readonly noteIdValue: string;

  async connect(): Promise<void> {
    const save = lodash.debounce(this.performSave.bind(this), 300);

    const noteShowResponse = await api.Notes.show({id: this.noteIdValue});

    const editor = new EditorJS({
      holder: "editorjs-target",
      placeholder: "Press Tab to select a block",
      defaultBlock: "paragraph",
      inlineToolbar: ["bold", "italic", "fillIn"],
      tools: { 
        paragraph: {
          class: Paragraph,
          config: {
            placeholder: "Press 'Tab' for options",
            preserveBlank: true
          },
          inlineToolbar: true
        },
        header: {
          class: Header,
          inlineToolbar: true
        },
        list: {
          inlineToolbar: true,
          class: NestedList
        },
        quote: Quote,
        table: {
          class: Table,
          inlineToolbar: true
        },
        fillIn: FillInTool
      },
      onChange: async (api, event) => {
        save(await editor.save());
      },
      data: noteShowResponse.data?.editor_data || {}
    });

    setTimeout(() => {
      const editor = this.element.querySelector(".codex-editor");

      if (editor)
        editor.setAttribute("data-turbo-cache", "false")
      else
        throw new Error("can't set data-turbo-cache=false on editor.js element because it's null");
    }, 300);
  }

  async performSave(data: Object): Promise<void> {
    const updateResponse = await api.Notes.update({id: this.noteIdValue, editor_data: data});

    if (!updateResponse.success)
      alert("Unable to update note data")
  }
}
