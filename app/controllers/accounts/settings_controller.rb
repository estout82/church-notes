# frozen_string_literal: true

# Allows users to manage the settings of an account
class Accounts::SettingsController < ApplicationController
  before_action :require_login!
  before_action :require_account!
  before_action :require_permission!
  before_action { @current_page = :account_settings }

  def show; end

  private

  #
  # actions
  #

  def require_account!
    @account = Account.find_by! alt_id: params[:account_id]

    if @account.blank?
      toast(
        "Sorry, we couldn't find that account",
        status: :not_found
      )
    end
  end

  def require_permission!
    unless current_user.permissions.for_account? @account, :admin
      toast(
        "Sorry, you're not allowed to manage settings for #{@account.name}",
        status: :forbidden
      )
    end
  end
end
