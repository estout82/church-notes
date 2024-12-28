# frozen_string_literal: true

#
# Represents a unique view of a note on the external note viewer
#
class Interactions::NoteView < Interaction
  store_accessor :data, :note_id
end
