#
# Represents an occurrence of a schedule on a single day. Used to deal
# with schedule and date combinations.
#

class Schedule::Occurrence
  attr_reader :date, :schedule

  def initialize(date:, schedule:)
    @date = date
    @schedule = schedule
  end
end
