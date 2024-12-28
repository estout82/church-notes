#
# Encapsulates onboarding behavior for an account
#

class Accounts::Onboarding
  include ActiveModel::Model

  attr_accessor :account

  def show?
    account.notes.blank? || account.schedules.blank? || account.created_at > Time.current - 1.month
  end

  def completed_create?
    account.notes.present?
  end

  def completed_schedule?
    account.schedules.present?
  end

  def completed_share?
    # at least one note view
    false
  end

  def completed_analyze?
    # visited analytics page
    false
  end
end
