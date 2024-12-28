# frozen_string_literal: true

# Responsible for sending filled-in notes in emails
class External::Notes::EmailsController < External::BaseController
  before_action :set_note!

  def new
    @external_note_email = External::Notes::Email.new email: current_user&.email
  end

  def create
    @external_note_email = External::Notes::Email.new email_params

    # create or match user from this org
    # create an instance with these fill-ins

    if @external_note_email.valid?
      @external_note_email.process(note: @note)

      HandleNoteEmailJob.perform_later(
        user: current_user,
        note: @note,
        email: @external_note_email.email
      )

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  #
  # actions
  #

  def set_note!
    @note = Note.find_by! alt_id: params[:note_alt_id]
  end

  #
  # params
  #

  def email_params
    params
      .require(:external_notes_email)
      .permit(:email, :fill_in_values)
  end
end
