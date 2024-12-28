# frozen_string_literal: true

# Represents a message between two users
class Message < ApplicationRecord
  include ActionView::Helpers::DateHelper
  include ActionView::RecordIdentifier
  include Message::Recipientable

  belongs_to :recipient, polymorphic: true
  belongs_to :context, polymorphic: true, optional: true
  belongs_to :sender, class_name: "User", optional: true

  has_many :messages, as: :recipient

  def sent_at_summary
    "#{sender.first_name} #{sender.last_name} #{distance_of_time_in_words created_at, Time.current} ago"
  end

  def created_at_summary
    "#{distance_of_time_in_words created_at, Time.current} ago"
  end

  def broadcast
    if recipient.is_a? Note
      note = recipient

      broadcast_prepend_later_to note.discussion_stream_id,
        partial: "external/notes/message",
        locals: { message: self, note: },
        target: "messages"

      broadcast_replace_later_to note.discussion_stream_id,
        partial: "external/notes/discussion/button",
        locals: { note: },
        target: note.discussion_button_dom_id

    elsif recipient.is_a? BlockReference
      note = recipient.note

      broadcast_prepend_later_to note.discussion_stream_id,
        partial: "external/notes/blocks/message",
        locals: { message: self, note: },
        target: recipient.message_list_id

      broadcast_replace_later_to note.discussion_stream_id,
        partial: "external/notes/blocks/add_response_button",
        locals: { block: recipient },
        target: recipient.new_message_turbo_frame_id
    end
  end

  def destroy_later
    MessageDestroyJob.perform_later(
      message: self,
      note: context
    )
  end

  def message_recipient_type
    "message"
  end

  def message_recipient_id
    id
  end

  def list_item_id
    dom_id self
  end
end
