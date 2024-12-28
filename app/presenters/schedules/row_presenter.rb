#
# Used to render schedule rows
#

class Schedules::RowPresenter
  def initialize(start_at:, end_at:, user:, account:)
    @start_at = start_at
    @end_at = end_at
    @user = user
    @account = account
  end

  def schedules
    schedules = ScheduleDecider.new(
      start_at: @start_at,
      end_at: @end_at,
      account: @account,
      user: @user
    ).run
  end

  def start_column(schedule:)
    diff = (schedule.start_at - @start_at).to_i / 60 / 60 / 24

    if diff >= 0
      diff + 1
    else
      1
    end
  end

  def end_column(schedule:)
    diff = (@end_at - schedule.end_at).to_i / 60 / 60 / 24

    if diff > 0
      8 - diff
    else
      8
    end
  end

  def overflow_classes(schedule:)
    # Returns classes to indicate that the schedule continues into the previous
    # or next week depending on schedule's start / end DateTime.

    classes = []

    if schedule.end_at > @end_at
      # overflow to right
      classes << "-mr-8"
    else
      # does not overflow to right, round the corners
      classes << "rounded-r"
    end

    if schedule.start_at < @start_at
      # overflow to left
      classes << "-ml-8"
    else
      # does not overflow to left, round the corners
      classes << "rounded-l"
    end

    classes.join " "
  end
end
