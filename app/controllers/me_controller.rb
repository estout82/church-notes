#
# Allows a user to update themselves
#

class MeController < ApplicationController
  before_action :require_login!

  def update
    if current_user.update(update_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  #
  # params
  #

  def add_account_roles_params
    params.permit(:account_id)
  end

  def update_params
    params.require(:user).permit(:time_zone)
  end
end