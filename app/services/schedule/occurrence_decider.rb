#
# Generates a list of Schedule::Occurrences given a schedule.
#

class Schedule::OccurrenceDecider
  def self.run(schedule:, timezone:)
    new(schedule:, timezone:).run
  end

  def initialize(schedule:, timezone:)
    @schedule = schedule
    @timezone = timezone
  end

  def run
    itr_date = @schedule
      .start_at
      .in_time_zone(@timezone)
      .to_date

    schedule_end_in_zone = @schedule
      .end_at
      .in_time_zone(@timezone)
      .to_date

    occurrences = []

    while itr_date <= schedule_end_in_zone
      occurrences << Schedule::Occurrence.new(
        date: itr_date,
        schedule: @schedule
      )

      itr_date = itr_date.next_day
    end

    occurrences
  end
end
