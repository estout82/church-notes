# frozen_string_literal: true

# Displays the homepage of the application
class HomeController < ApplicationController
  before_action :require_login!
  before_action { require_permission! :any }
  before_action { @current_page = :home }

  def index
    @path = request.original_fullpath

    @account_note_views_data = Analytics::AccountNoteViewsData.new(
      user: current_user,
      account: current_account
    )

    @live_notes = LiveNoteDecider.new(account: current_account).run

    @onboarding = current_account.onboarding
  end
end
