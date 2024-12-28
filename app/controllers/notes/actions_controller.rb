# frozen_string_literal: true

# Follow ups
class Notes::ActionsController < ApplicationController
  before_action :require_login!
  before_action :require_editor!
  before_action :set_note!
  before_action :set_policy
  before_action { @current_page = :notes }
  before_action { @current_sub_page = :actions }

  def index
    @follow_ups = @note.actions
  end

  def new
    @action = Actions::Types::FollowUp.new note: @note
  end

  def create
    @action = Actions::Types::FollowUp.new action_params
    @action.note = @note

    if @action.save
      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_editor!
    unless current_user.permissions.for_account? current_account, :editor
      toast(
        "Sorry, you're not allowed to edit notes for this account",
        status: :forbidden
      )
    end
  end

  def set_note!
    @note = Note.find_by! alt_id: params[:note_alt_id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we couldn't find that note",
      status: :not_found
    )
  end

  def set_policy
    @policy = NotePolicy.new current_user, current_account, @note
  end

  def action_params
    params
      .require(:actions_types_follow_up)
      .permit(:delay_unit, :delay_value, :message)
  end
end
