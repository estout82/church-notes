# frozen_string_literal: true

# Represents a note page
class Note < ApplicationRecord
  include Policable

  belongs_to :account

  has_many :messages, -> { order(created_at: :desc) }, as: :recipient, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :instances, class_name: "NoteInstance", dependent: :destroy
  has_many :actions, dependent: :destroy
  has_many :executions, through: :actions, class_name: "Actions::Execution", dependent: :destroy
  has_many :block_references, dependent: :destroy

  has_one_attached :banner

  enum :sharing, { default_sharing: 0, sub_account_sharing: 1, organization_sharing: 2 }

  before_create { self.alt_id = SecureRandom.alphanumeric(10).downcase }

  def view_count
    Interactions::NoteView
      .where("interactions.data ->> 'note_id' = ?", id.to_s)
      .count
  end

  def best_banner_url
    if banner.attached?
      banner.url
    else
      banner_url
    end
  end

  def banner?
    banner.attached? || banner_url.present?
  end

  def create_executions_for(user:)
    actions.map do |action|
      Actions::Execution.create!(
        action:,
        user:,
        status: :initial,
        run_at: action.execute_at(anchor: Time.current)
      )
    end
  end

  def discussion_stream_id
    "#{alt_id}_discussion"
  end

  def discussion_button_dom_id
    "#{alt_id}_discussion_button"
  end

  def message_recipient_type
    "note"
  end

  def message_recipient_id
    alt_id
  end

  def to_api_object
    {
      title:,
      editor_data:
    }
  end

  def to_param
    alt_id
  end

  # Represents a single block from the editor data
  class EditorBlock
    attr_accessor :id, :type, :data, :note

    def initialize(id:, type:, note:, data: {})
      self.id = id
      self.type = type
      self.data = data
      self.note = note
    end

    def messages
      reference = note
        .block_references
        .find { |ref| ref.referenced_block_id == id }

      if reference.present?
        reference.messages
      else
        []
      end
    end

    def to_partial_path
      "external/notes/blocks/#{type}"
    end

    def to_email_partial_path
      "note_mailer/blocks/#{type}"
    end

    def to_download_partial_path
      "external/notes/downloads/blocks/#{type}"
    end

    def new_message_turbo_frame_id
      "block_#{id}_new_message"
    end

    def message_list_id
      "block_#{id}_message_list"
    end

    def message_recipient_id
      id
    end
  end

  # Converts block data into a more ruby friendly format
  # TODO refactor this
  def friendly_editor_data
    return [] if editor_data&.dig("blocks").blank?

    editor_data["blocks"].map do |block|
      EditorBlock.new(
        id: block["id"],
        type: block["type"],
        data: block["data"],
        note: self
      )
    end
  end
end
