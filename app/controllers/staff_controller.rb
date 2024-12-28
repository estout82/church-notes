#
# Displays the admin (staff) ui
#

class StaffController < ApplicationController
  before_action :require_login!
  before_action :require_staff!

  def show
  end

  private

  #
  # actions
  #

  def require_staff!
    unless current_user.is_staff
      toast(
        "No",
        path: login_path,
        status: :not_found
      )
    end
  end
end
