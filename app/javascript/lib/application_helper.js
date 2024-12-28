
const PRODUCTION_LOGIN_URL= "https://app.notespro.church/login";

function getCurrentUserId() {
  return document.body.getAttribute("data-current-user-id");
}

function getCurrentUserName() {
  return document.body.getAttribute("data-current-user-name");
}

function getCurrentUserEmail() {
  return document.body.getAttribute("data-current-user-email");
}

export default {
  getCurrentUserId,
  getCurrentUserName,
  getCurrentUserEmail,
  PRODUCTION_LOGIN_URL
};