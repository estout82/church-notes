# frozen_string_literal: true

#
# Creates an interaction for an external note view
#
class HandleNoteViewJob < ApplicationJob
  def perform(user:, note:)
    Interactions::NoteView.create!({
      user:,
      note_id: note.id
    })
  end
end
