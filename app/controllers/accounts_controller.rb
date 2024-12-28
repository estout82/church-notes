# frozen_string_literal: true

# Controls accounts and sub accounts
class AccountsController < ApplicationController
  before_action :require_login!
  before_action :set_account!, only: [:update_link_redirects, :toggle_can_have_subaccounts]
  before_action :set_policy!
  before_action :require_admin_permission!, only: [:update_link_redirects, :toggle_can_have_subaccounts]

  def toggle_can_have_subaccounts
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to edit that account",
        status: :forbidden,
        path: root_path
      )

      return
    end

    new_can_have_sub_accounts = !@account.can_have_sub_accounts

    # cannot de-activate sub accounts for an account that has active sub accounts
    if !new_can_have_sub_accounts && @account.sub_accounts?
      toast(
        "Sorry, you can't turn off sub accounts for #{@account.name} because it has active sub accounts",
        status: :unprocessable_entity
      )

      return
    end

    if @account.update can_have_sub_accounts: new_can_have_sub_accounts
      toast(
        "Sub-Accounts are #{new_can_have_sub_accounts ? 'enabled' : 'disabled'} for #{@account.name}",
        status: :ok
      )
    else
      toast(
        "Sorry, we weren't able to update #{@subaccount.name}",
        status: :unprocessable_entity
      )
    end
  end

  def update_link_redirects
    unless @policy.can_update?
      toast(
        "Sorry, you're not allowed to update that account",
        status: :forbidden,
        path: root_path
      )

      return
    end

    # Toggles the setting that determines if the account link redirects to the current note or not
    @account.link_redirects = update_link_redirects_params[:link_redirects]

    if @account.save
      @live_notes = LiveNoteDecider.new(account: @account).run

      respond_to :turbo_stream
    else
      head :bad_request
    end
  end

  private

  #
  # actions
  #

  def set_account!
    @account = Account.find params[:id]

    unless @account.present?
      toast(
        "Sorry, we couldn't find that account",
        status: :not_found
      )
    end
  end

  def set_policy!
    @policy = AccountPolicy.new(current_user, current_account, @account)
  end

  def require_owner_permission!
    unless current_user.permissions.for_account? @account, :owner
      toast(
        "Sorry, you have to be an owner on #{@account.name}",
        status: :forbidden
      )
    end
  end

  def require_admin_permission!
    unless current_user.permissions.for_account? @account, :admin
      toast(
        "Sorry, you have to be an admin of #{@account.name}",
        status: :forbidden
      )
    end
  end

  #
  # params
  #

  def account_params
    params
      .require(:account)
      .permit(:name, :parent_account_id)
  end

  def update_link_redirects_params
    params
      .require(:account)
      .permit(:link_redirects)
  end
end
