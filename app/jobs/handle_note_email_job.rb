# frozen_string_literal: true

class HandleNoteEmailJob < ApplicationJob
  def perform(user:, email:, note:)
    Interactions::NoteEmail.create!(
      user:,
      note_id: note.id,
      email:
    )
  end
end
