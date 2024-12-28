# frozen_string_literal: true

# Sends an email to someone a certain period after they fill out the notes
class Actions::Types::FollowUp < Action
  include ActionView::Helpers::TextHelper

  store_accessor :data, :message, :delay_unit, :delay_value

  validates :message, presence: true
  validates :delay_unit, presence: true
  validates :delay_value, presence: true, numericality: { only_integer: true }

  def delay_message
    "#{pluralize delay_value.to_i, delay_unit} later"
  end

  def delay_unit_options
    if Rails.env.development?
      [["Seconds", :seconds], ["Minutes", :minutes], ["Hours", :hours], ["Days", :days], ["Weeks", :weeks]]
    else
      [["Hours", :hours], ["Days", :days], ["Weeks", :weeks]]
    end
  end
end
