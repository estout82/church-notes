# frozen_string_literal: true

# Allows all users to view accounts (ie campuses)
class External::AccountsController < External::BaseController
  before_action :set_account!
  before_action -> { current_external_organization_is @account.organization }

  def show
    if @account.link_redirects? && @account.redirect_note.present?
      redirect_to external_note_path(@account.redirect_note)
      return
    end

    @live_notes = LiveNoteDecider.new(account: @account).run
    @past_notes = PastNoteDecider.new(account: @account).run
  end

  private

  def set_account!
    @account = Account.find_by! alt_id: params[:alt_id]
  end
end
