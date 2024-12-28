#
# Controls account logos
#

class Accounts::Settings::LogoController < ApplicationController
  before_action :require_login!
  before_action :require_permission!
  before_action :require_account!

  def edit
  end

  def update
    if @account.update update_params
      respond_to :turbo_stream
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  #
  # actions
  #

  def require_permission!
    unless current_user.permissions.for_account? current_account, :admin
      toast(
        "Sorry, you're not allowed to do that",
        status: :forbidden
      )
    end
  end

  def require_account!
    @account = Account.find params[:account_id]
  rescue ActiveRecord::RecordNotFound
    toast(
      "Sorry, we couldn't find that account",
      status: :not_found
    )
  end

  #
  # params
  #

  def update_params
    params
      .require(:account)
      .permit(:logo)
  end
end
