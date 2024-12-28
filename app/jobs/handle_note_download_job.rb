# frozen_string_literal: true

class HandleNoteDownloadJob < ApplicationJob
  def perform(user:, note:)
    Interactions::NoteDownload.create!(
      user:,
      note_id: note.id
    )
  end
end
