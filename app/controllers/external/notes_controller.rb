# frozen_string_literal: true

# Controls note pages for external users
class External::NotesController < External::BaseController
  before_action :set_note
  before_action -> { current_external_organization_is @note.account.organization }

  def show
    @preview = params.fetch(:preview, nil).present?

    unless @preview
      # don't want to store interactions if this is a preview

      @new_message = Message.new

      @instance = if current_user
        NoteInstance.for(
          user: current_user,
          note: @note
        )
      end

      HandleNoteViewJob.perform_later(
        user: current_user,
        note: @note
      )
    end
  end

  private

  def set_note
    @note = Note.find_by! alt_id: params[:alt_id]
  end
end
