# frozen_string_literal: true

require "json"

class External::Notes::Email
  include ActiveModel::Model

  attr_accessor :email, :fill_in_values

  FillInValue = Struct.new :id, :value, keyword_init: true do
    def serialize
      { id:, value: }
    end
  end

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email is invalid" }

  def process(note:)
    values_parsed = JSON.parse(fill_in_values)

    values = values_parsed.map do |parsed|
      FillInValue.new(
        id: parsed["id"],
        value: parsed["value"]
      )
    end

    # Ensure user exists
    organization = note.account.organization
    user = organization.ensure_external_user_for email: email

    # Create an instance
    instance = NoteInstance.for user: user, note: note
    instance.update! fill_in_values: values_parsed

    # Create & enqueue action executions
    executions = note.create_executions_for user: user
    executions.map(&:enqueue!)

    NoteMailer
      .with(
        recipient_email: email,
        note:,
        fill_in_values: values.map(&:serialize)
      )
      .external
      .deliver_later
  end
end
