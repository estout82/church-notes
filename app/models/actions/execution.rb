# frozen_string_literal: true

class Actions::Execution < ApplicationRecord
  self.table_name = "action_executions"

  belongs_to :action
  belongs_to :user

  has_many :messages, as: :recipient

  enum :status, { initial: 0, completed: 1, failed: 2 }

  scope :for, ->(user:) { where(user:) }

  def enqueue!
    raise if run_at <= Time.current

    Actions::ExecutionJob
      .set(wait_until: run_at)
      .perform_later(execution: self)
  end
end
