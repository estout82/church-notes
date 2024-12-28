# frozen_string_literal: true

class Actions::ExecutionJob < ApplicationJob
  def perform(execution:)
    # send the message

    Message.create!(
      recipient: execution.user,
      sender: nil,
      context: execution.action,
      content: execution.action.message
    )

    # Send a follow-up mailer
  end
end
