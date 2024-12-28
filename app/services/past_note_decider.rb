# frozen_string_literal: true

# Returns an account's past notes
class PastNoteDecider
  attr_accessor :account

  def initialize(account:)
    self.account = account
  end

  def run
    account
      .schedules
      .where("end_at <= ?", Time.current)
      .order(end_at: :desc)
      .extract_associated(:note)
  end
end
