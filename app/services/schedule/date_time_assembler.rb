#
# Assembles a date_time given an ISO date string and an ISO time string.
#
# REFACTOR this can probably be a parameter object
#

class Schedule::DateTimeAssembler
  def self.run(date_iso:, time_iso:)
    new(date_iso:, time_iso:).run
  end

  def initialize(date_iso:, time_iso:)
    @date_iso = date_iso
    @time_iso = time_iso
  end

  def run
    date = Date.parse @date_iso
    time = Time.parse @time_iso

    offset = time.utc_offset / 60 / 60

    offset_string = offset >= 0 ? "+#{offset}" : "-#{offset.abs}"

    DateTime.new(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.min,
      time.sec,
      offset_string
    )
  end
end