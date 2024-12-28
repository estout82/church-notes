# frozen_string_literal: true

# Represents a user's relationship with a note
class NoteInstance < ApplicationRecord
  belongs_to :user
  belongs_to :note

  def self.for(user:, note:)
    find_or_create_by!(
      user:,
      note:
    )
  end
end
