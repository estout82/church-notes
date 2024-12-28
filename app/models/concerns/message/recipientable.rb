# frozen_string_literal: true

# Allows a model to be a message recipient
module Message::Recipientable
  def new_message_turbo_frame_id
    "#{model_name.param_key}_#{id}_new_message"
  end

  def new_message_form_id
    "#{model_name.param_key}_#{id}_new_message_form"
  end
end
