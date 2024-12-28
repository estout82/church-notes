# frozen_string_literal: true

# Returns the notes that are currently scheduled given an account
class LiveNoteDecider
  def initialize(account:)
    @account = account
  end

  def run
    return Note.none if @account.blank?

    now = Time.current

    @account
      .schedules
      .where("start_at <= ?", now)
      .where("end_at >= ?", now)
      .order(created_at: :desc)
      .map(&:note)
  end
end
