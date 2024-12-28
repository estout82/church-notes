# frozen_string_literal: true

#
# Used to prepare application level data for views
#
class ApplicationPresenter
  def initialize(user = nil, account = nil)
    @user = user
    @account = account
    @permissions = @user&.permissions
  end

  def organization_name
    @account.organization.name
  end

  def user_utc_offset_in_hours
    offset_in_seconds = Time
      .current
      .in_time_zone(@user.time_zone)
      .utc_offset

    offset_in_seconds / 60 / 60
  end
end
