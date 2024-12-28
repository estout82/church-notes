# frozen_string_literal: true

# Allows users to sign in and out on external pages
class External::AuthenticationController < External::BaseController
  before_action :set_note

  def create
    @frame_id = params[:frame_id]
    @attempt = External::AuthenticationAttempt.from_params create_params

    if @attempt.authenticated?
      persist_current_user user: @attempt.user
      current_user_is @attempt.user

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_note
    id = params[:from_note_alt_id]
    @note = Note.find_by!(alt_id: id) if id
  end

  def create_params
    params
      .require(:external_authentication_attempt)
      .permit(:email, :password)
  end
end
