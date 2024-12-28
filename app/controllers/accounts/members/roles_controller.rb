# frozen_string_literal: true

# Allows a user to edit the roles for a user that is a member of an account
# on the account users settings page.
class Accounts::Members::RolesController < ApplicationController
  before_action :require_login!
  before_action :require_account!
  before_action :require_permission!
  before_action :require_member!

  def edit; end

  def update
    roles = update_params[:role_names]

    if @member.update_roles roles
      respond_to :turbo_stream
    else
      toast(
        "Sorry, we weren't able to update that user's role",
        status: :unprocessable_entity
      )
    end
  end

  private

  #
  # actions
  #

  def require_account!
    @account = Account.find_by! alt_id: params[:account_id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we couldn't find that account",
      status: :not_found
    )
  end

  def require_permission!
    unless current_user.permissions.for_account? @account, :admin
      toast(
        "Sorry, you're not allowed to manage users for #{@account.name}",
        status: :forbidden
      )
    end
  end

  def require_member!
    @member = @account.members.find params[:member_id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, you're we couldn't find that user in #{@account.name}",
      status: :not_found
    )
  end

  #
  # params
  #

  def update_params
    params
      .require(:user_account_member)
      .permit(role_names: [])
  end
end
