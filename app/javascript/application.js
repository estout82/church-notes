import "@hotwired/turbo-rails";
import "./controllers";
import LogRocket from "logrocket";
import ApplicationHelper from "./lib/application_helper";

if (process.env.NOTES_PRO_ENV == "production") {
  LogRocket.init("notespro/notespro");

  LogRocket.identify(
    ApplicationHelper.getCurrentUserId(), 
    {
      name: ApplicationHelper.getCurrentUserName(),
      email: ApplicationHelper.getCurrentUserEmail()
    }
  );
}
