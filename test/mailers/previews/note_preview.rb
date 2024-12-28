# frozen_string_literal: true

#
# Preview for note mailers
#
class NotePreview < ActionMailer::Preview
  def external
    note_email = External::Notes::Email.new({
      email: "test@test.com"
    })

    NoteMailer
      .with(
        note_email:,
        note: Note.last
      )
      .external
  end
end
