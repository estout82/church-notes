#
# Represents the period of time that a note is available
#

class Schedule < ApplicationRecord
  include Policable

  belongs_to :note
  belongs_to :account

  validates :note_id, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
end
