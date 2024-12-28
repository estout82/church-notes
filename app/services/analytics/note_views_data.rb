#
# Generates data for the note views chart
#

class Analytics::NoteViewsData
  def initialize(note:, user:)
    @note = note
    @user = user
  end

  def labels
    31.times.map do |n|
      if n == 0 || n == 31 || n % 3 == 0
        (Time.current.in_time_zone(@user.time_zone) - (n.days + 1))
          .beginning_of_day
          .strftime("%b %d")
      else
        ""
      end
    end
  end

  def values
    31.times.map do |n|
      start_time = (Time.current.in_time_zone(@user.time_zone) - (n.days + 1)).beginning_of_day
      end_time = start_time.end_of_day

      Interactions::NoteView
        .where("(data ->> 'note_id')::integer = ?", @note.id)
        .where("created_at >= ?", start_time)
        .where("created_at <= ?", end_time)
        .count
    end
  end
end
