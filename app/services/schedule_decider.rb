#
# Returns schedules that fall within the given dates
#

class ScheduleDecider
  include DateHelper

  def initialize(start_at:, end_at:, account:, user:)
    @account = account
    @user = user
    @start_at = start_at.utc
    @end_at = end_at.utc
  end

  def run
    Schedule
      .joins(:note)
      .where(account_id: @account.id)
      .merge(
        Schedule
          .where( # start in and end in
            "start_at <= ? AND end_at >= ?",
            @end_at,
            @start_at
          )
          .or( # start before and go after
            Schedule.where(
              "start_at <= ? AND end_at >= ?",
              @start_at,
              @end_at
            )
          )
          .or( # start before and go in
            Schedule.where(
              "start_at <= ? AND end_at >= ?",
              @start_at,
              @start_at
            )
          )
          .or( # start in and go after
            Schedule.where(
              "start_at <= ? AND end_at >= ?",
              @end_at,
              @end_at
            )
          )
      )
  end
end