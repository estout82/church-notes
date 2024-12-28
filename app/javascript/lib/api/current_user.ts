
import Rails from "@rails/ujs";

export async function updateTimeZone(timezone) {
  const res = await fetch("/me", {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": Rails.csrfToken()
    },
    body: JSON.stringify({
      user: {
        time_zone: timezone
      }
    })
  });

  if (res.ok)
    return true;
}
