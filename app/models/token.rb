# frozen_string_literal: true

#
# Represents a security in the app
#
class Token < ApplicationRecord
  belongs_to :user

  enum :action, {
    no_action: 0,
    password_reset: 1
  }

  before_create { self.alt_id = SecureRandom.alphanumeric(10).downcase }

  def to_partial_path
    "tokens/#{action}"
  end

  def to_param
    alt_id
  end
end
