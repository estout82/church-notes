#
# Controls analytics for note pages
#
class Notes::AnalyticsController < ApplicationController
  before_action :require_login!
  before_action :require_permission!
  before_action :require_note!
  before_action :set_policy
  before_action { @current_page = :notes }
  before_action { @current_sub_page = :analytics }

  def show
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit that note",
        status: :forbidden
      )

      return
    end

    @note_views_data = Analytics::NoteViewsData.new(
      note: @note,
      user: current_user
    )

    @people_data = Analytics::NotePeopleData.new(
      note: @note
    ).data
  end

  private

  def require_permission!
    unless current_user.permissions.for_account? current_account, :editor
      toast(
        "Sorry, you're not allowed to edit notes for this account",
        status: :forbidden
      )
    end
  end

  def require_note!
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
end
