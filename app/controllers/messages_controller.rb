# frozen_string_literal: true

# Allows users to send messages
class MessagesController < ApplicationController
  # We need to set the context first because sometimes the context is used in determining the recipient
  before_action :set_context

  before_action :require_recipient, only: [:new, :create]
  before_action :require_sender, only: :create
  before_action :require_message, only: :destroy

  def new
    @message = Message.new(
      recipient: @recipient,
      sender: current_user
    )
  end

  def create
    @message = Message.new message_params
    @message.recipient = @recipient
    @message.context = @context
    @message.sender = @sender

    if @message.save
      @message.broadcast

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # TODO: check message perms here
    is_sender = @message.sender == current_user
    is_note_context_message = @message.context.is_a? Note

    if !is_sender && !is_note_context_message
      # Can only delete messages in a note context for now (not action context)
      head :bad_request
      return
    end

    has_editor_permission = current_user.permissions.for_account?(@message.context.account, :editor)
    can_delete_message = (has_editor_permission || is_sender)

    if can_delete_message
      @message.destroy_later

      head :ok
    else
      head :forbidden
    end
  end

  private

  def message_params
    params
      .require(:message)
      .permit(:content, :recipient_type, :recipient_id, :sender_id, :context_type, :context_id)
  end

  def set_context
    params_to_use = params[:message].present? ? message_params : params
    type = params_to_use[:context_type]

    @context = if type == "note"
      Note.find params_to_use[:context_id]

    elsif %w[action actions_types_follow_up].include?(type)
      Action.find params_to_use[:context_id]

    elsif type == "message"
      Message.find params_to_use[:context_id]

    else
      raise "Unknown message context type '#{type}'"
    end
  end

  def require_recipient
    params_to_use = params[:message].present? ? message_params : params
    type = params_to_use[:recipient_type]
    id = params_to_use[:recipient_id]

    @recipient = if type == "note"
      Note.find id

    elsif %w[action actions_types_follow_up].include?(type)
      Action.find id

    elsif type == "message"
      Message.find id

    elsif type == "block"
      # Find or create a database block corresponding to the editor's data block

      block_reference = BlockReference.find_or_create_by!(
        note: @context,
        referenced_block_id: id
      )

      if block_reference.blank?
        raise "Createing a block message requires context. context_type #{params_to_use[:context_type]}, context_id #{params_to_use[:context_id]}"
      end

      block_reference

    elsif type == "block_reference"
      block_reference = BlockReference.find params_to_use[:recipient_id]

    else
      raise "Unknown message recipient type '#{type}'"
    end

    raise "Message recipient is unknown type: #{type}, id #{id}" if @recipient.blank?
  end

  def require_message
    @message = Message.find params[:id]
  end

  def require_sender
    @sender = User.find message_params[:sender_id]
  end
end
