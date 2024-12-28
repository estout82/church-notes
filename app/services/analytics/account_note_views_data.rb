#
# Generates data for the account note views chart
#

class Analytics::AccountNoteViewsData
  def initialize(account:, user:)
    @account = account
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
    account_note_ids = Note.where(account: @account).ids

    31.times.map do |n|
      start_time = (Time.current.in_time_zone(@user.time_zone) - (n.days + 1)).beginning_of_day
      end_time = start_time.end_of_day

      Interactions::NoteView
        .where("(data ->> 'note_id')::integer IN (?)", account_note_ids)
        .where("created_at >= ?", start_time)
        .where("created_at <= ?", end_time)
        .count
    end
  end
end
