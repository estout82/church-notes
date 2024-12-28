/**
 * Api client for Note models
 */

import { ApiResponse } from "../api";
import Rails from "@rails/ujs";

export type NoteShowData = {
  title: string;
  editor_data: any
};

export async function show(params: {id: string}): Promise<ApiResponse<NoteShowData>> {
  const url = `/notes/${params.id}`;

  try {
    const response = await fetch(url, {
      method: "GET",
      headers: {
        "Accept": "application/json"
      }
    });

    if (response.ok) {
      return {
        success: true,
        data: await response.json()
      }
    } else {
      return {
        success: false,
        data: null
      }
    }
  } catch (error) {
    throw error;
  }
}

export async function update(params: {id: string, editor_data: Object}): Promise<ApiResponse<null>> {
  const url = `/notes/${params.id}`;

  try {
    const response = await fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": Rails.csrfToken(),
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({note: {editor_data: params.editor_data}})
    });

    if (response.ok) {
      return {
        success: true,
        data: null
      }
    } else {
      return {
        success: false,
        data: null
      }
    }

  } catch (error) {
    throw error;
  }
}
