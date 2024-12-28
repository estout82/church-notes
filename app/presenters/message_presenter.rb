# frozen_string_literal: true

# Contains view logic for messages
class MessagePresenter
  attr_accessor :message, :note, :current_user

  def initialize(message, note:, current_user:)
    self.message = message
    self.note = note
    self.current_user = current_user
  end

  def show_three_dots?
    show_delete?
  end

  def show_delete?
    current_user.present? && (
      current_user.permissions.for_account?(note.account, :editor) ||
      message.sender == current_user
    )
  end
end
