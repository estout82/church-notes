# frozen_string_literal: true

#
# Notes in email form
#
class NoteMailer < ApplicationMailer
  def external
    @email = params[:recipient_email]
    @note = params[:note]

    @renderer = Note::EmailRenderer.new(
      note: @note,
      fill_in_values: params[:fill_in_values].presence || []
    )

    mail from: "notes@notespro.church", to: @email, subject: @note.title
  end
end
