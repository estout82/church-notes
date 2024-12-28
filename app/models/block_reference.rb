# frozen_string_literal: true

# Stores a reference in the database to an editor.js block. Used for comments (messages).
class BlockReference < ApplicationRecord
  belongs_to :note

  has_many :messages, -> { order(created_at: :desc) }, as: :recipient, dependent: :destroy

  validates :referenced_block_id, presence: true, uniqueness: true

  def new_message_turbo_frame_id
    "block_#{referenced_block_id}_new_message"
  end

  def new_message_form_id
    "block_#{referenced_block_id}_new_message_form"
  end

  def message_list_id
    "block_#{referenced_block_id}_message_list"
  end

  def message_recipient_type
    "block_reference"
  end

  def message_recipient_id
    referenced_block_id
  end
end
