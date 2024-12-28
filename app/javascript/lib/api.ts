/**
 * Module to assist with interacting with the application's API
 */

export type ApiResponse<T = any> = {
  success: Boolean;
  error?: string;
  data: T | null;
};

import * as CurrentUser from "./api/current_user";
import * as NoteInstances from "./api/note_instances";
import * as Notes from "./api/notes";

export default {
  CurrentUser,
  Notes,
  NoteInstances
};
