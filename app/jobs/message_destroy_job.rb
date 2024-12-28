# frozen_string_literal: true

# Destroys a message. Has to be done async to avoid missing data for the turbo stream broadcasts
class MessageDestroyJob < ApplicationJob
  include Turbo::Broadcastable

  def perform(message:, note:)
    broadcast_remove_to note.discussion_stream_id, target: message.list_item_id
    message.destroy
  end
end
