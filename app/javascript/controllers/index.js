// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import {Application} from "@hotwired/stimulus";

const application = Application.start();

application.debug = false;
window.Stimulus   = application;

import ApplicationController from "./application_controller.js";
application.register("application", ApplicationController);

import BlockController from "./block_controller.js";
application.register("block", BlockController);

import ClipboardController from "./clipboard_controller";
application.register("clipboard", ClipboardController);

import DatePickerController from "./date_picker_controller.js";
application.register("date-picker", DatePickerController);

import DropdownController from "./dropdown_controller.js";
application.register("dropdown", DropdownController);

import External__CommentsController from "./external/comments_controller.js";
application.register("external--comments", External__CommentsController);

import External__NavController from "./external/nav_controller";
application.register("external--nav", External__NavController);

import External__NoteController from "./external/note_controller.js";
application.register("external--note", External__NoteController);

import External__Note__DownloadController from "./external/note/download_controller";
application.register("external--note--download", External__Note__DownloadController);

import External__Note__EmailController from "./external/note/email_controller";
application.register("external--note--email", External__Note__EmailController);

import External__Note__ResponseController from "./external/note/response_controller.ts";
application.register("external--note--response", External__Note__ResponseController);

import Forms__LoadingController from "./forms/loading_controller";
application.register("forms--loading", Forms__LoadingController);

import HomeController from "./home_controller";
application.register("home", HomeController);

import LoadingController from "./loading_controller";
application.register("loading", LoadingController);

import Nav__MobileController from "./nav/mobile_controller.js";
application.register("nav--mobile", Nav__MobileController);

import Note__AnalyticsController from "./note/analytics_controller";
application.register("note--analytics", Note__AnalyticsController);

import Note__EditController from "./note/edit_controller.js";
application.register("note--edit", Note__EditController);

import Note__SimpleEditorController from "./note/simple_editor_controller.ts";
application.register("note--simple-editor", Note__SimpleEditorController);

import NotePicker from "./note_picker";
application.register("note-picker", NotePicker);

import PlanSelectorController from "./plan_selector_controller.js";
application.register("plan-selector", PlanSelectorController);

import Schedule__IndexController from "./schedule/index_controller.js";
application.register("schedule--index", Schedule__IndexController);

import Schedule__AccountLinkSettingsController from "./schedule/account_link_settings_controller.js";
application.register("schedule--account-link-settings", Schedule__AccountLinkSettingsController);

import TimePickerController from "./time_picker_controller.js";
application.register("time-picker", TimePickerController);

import ToastController from "./toast_controller.js";
application.register("toast", ToastController);

import ToggleController from "./toggle_controller";
application.register("toggle", ToggleController);