# frozen_string_literal: true

# Represents an automation for a note - currently just follow-ups
class Action < ApplicationRecord
  belongs_to :note

  has_many :executions

  def execute_at(anchor:)
    # Calculate execution delay based on an anchor date
    anchor + delay_value.to_i.send(delay_unit)
  end
end
