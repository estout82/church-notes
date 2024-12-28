
import Rails from "@rails/ujs";

export async function updateFillInValue(data: {noteInstanceId: number, index: number, value: string | null}) {
  const res = await fetch(`/external/note_instances/${data.noteInstanceId}/fill_in_values/${data.index}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": Rails.csrfToken()
    },
    body: JSON.stringify({
      fill_in_value: {
        value: data.value
      }
    })
  });

  if (res.ok)
    return true;
}
