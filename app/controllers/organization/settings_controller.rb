#
# Allows the user to manage settings for the organization
#

class Organization::SettingsController < ApplicationController
  before_action :require_login!
  before_action :require_permission!
  before_action { @current_page = :organization_settings }

  def show
  end

  def update
    if current_organization.update(update_params)
    else
    end
  end

  private

  #
  # actions
  #

  def require_permission!
    unless current_user.permissions.for_account? current_organization.main_account, :admin
      toast(
        "Sorry, you don't have permission to do that",
        status: :forbidden
      )
    end
  end

  #
  # params
  #

  def update_params
    params
      .require(:organization)
      .permit(:image)
  end
end
