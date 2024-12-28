
import {Application} from "@hotwired/stimulus";

const application = Application.start();

import ApplicationController from "../application_controller";
application.register("application", ApplicationController);

import Marketing__ApplicationController from "./application_controller";
application.register("marketing--application", Marketing__ApplicationController);

import Forms__LoadingController from "../forms/loading_controller";
application.register("forms--loading", Forms__LoadingController);
