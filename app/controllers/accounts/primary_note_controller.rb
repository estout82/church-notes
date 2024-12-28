class Accounts::PrimaryNoteController < ApplicationController
  before_action :require_login!
  before_action :require_permission!
  before_action :require_account!

  def update
    if @account.update update_params
      @live_notes = LiveNoteDecider.new(account: @account).run
      respond_to :turbo_stream
    else
      toast(
        "Sorry, we weren't able to set the primary note for this account",
        status: :internal_server_error,
        level: :error
      )
    end
  end

  private

  #
  # actions
  #

  def require_permission!
    unless current_user.permissions.for_account?(current_account, :scheduling)
      toast(
        "Sorry, you're not allowed to manage the schedule for this account",
        status: :unauthorized,
        level: :error
      )
    end
  end

  def require_account!
    @account = current_account
  end

  #
  # params
  #

  def update_params
    params
      .require(:account)
      .permit(:primary_note_id)
  end
end
