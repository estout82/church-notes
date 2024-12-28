class SchedulePresenter
  include DateHelper

  def initialize(selected_date:, user:)
    @selected_date = selected_date
    @user = user
  end

  def start_date
    @selected_date.prev_month.end_of_month.prev_day(@selected_date.wday - 1)
  end

  def iteration_count
    if @selected_date.wday + @selected_date.end_of_month.day < 35
      35
    else
      42
    end
  end

  def date_text_color(date)
    if date.month != @selected_date.month
      "text-muted"
    else
      "text-muted"
    end
  end

  def schedules_for_date(date)
    offset = utc_offset timezone: @user.time_zone

    day_start = DateTime.new(
      date.year,
      date.month,
      date.day,
      0,
      0,
      0,
      offset
    ).utc

    day_end = DateTime.new(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      offset
    ).utc

    Schedule.where("start_at <= ? AND end_at >= ?", day_end, day_start).all
  end
end
