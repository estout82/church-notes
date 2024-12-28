# frozen_string_literal: true

# The top level container for each customer
class Organization < ApplicationRecord
  has_many :organization_members, dependent: :destroy
  has_many :users, through: :organization_members
  has_many :accounts, dependent: :destroy
  has_many :sub_accounts, -> { where(is_main: false) }, class_name: "Account"

  enum plan: { no_plan: 0, free: 1, base: 2, multisite: 3 }

  validates :name, :encoded_name, presence: true
  validates :encoded_name, uniqueness: true
  validates :encoded_name,
    format: {
      with: /[0-9a-z\-]+/,
      message: "Encoded name is invalid"
    }

  before_create { self.alt_id = SecureRandom.alphanumeric(10).downcase }

  def self.encode_name(name_to_encode)
    name_to_encode.downcase.gsub(/[^0-9a-z\-]/, "")
  end

  def main_account
    accounts.find_by(is_main: true)
  end

  def top_level_accounts
    accounts
      .where(parent_account: nil, is_main: false)
      .or(Account.where(parent_account: main_account))
      .order(name: :asc)
  end

  def plan_name
    return "No Plan" if no_plan?
    return "Free" if free?
    return "Base" if base?
    return "Multi-Site" if multisite?
  end

  def plan_features
    if multisite?
      [
        Feature.new(name: "Unlimited notes pages", description: "No limit for the number of note pages", enabled: true),
        Feature.new(name: "Account Link", description: "Easily share the currently scheduled note with one link",
          enabled: true),
        Feature.new(name: "Schedule notes in advance",
          description: "Use the scheduler to schedule notes to go live in the future", enabled: true),
        Feature.new(name: "Download notes", description: "Download note pages from the editor", enabled: false),
        Feature.new(name: "Analytics", description: "Track note views, emails, downloads and more", enabled: true),
        Feature.new(name: "Engagement Tracking", description: "See who in your ministry is viewing the note pages",
          enabled: true),
        Feature.new(name: "Remove NotesPro branding", description: "Upload your own logo and hide NotesPro logos",
          enabled: true),
        Feature.new(name: "Rock RMS Integration", description: "Record attendance and interactions in Rock RMS",
          enabled: true),
        Feature.new(name: "Multi-site support with subaccounts",
          description: "Create subaccounts for each campus or ministry", enabled: true),
        Feature.new(name: "Use your own domain name",
          description: "Use your church's own domain name to view notes on NotesPro", enabled: true),
        Feature.new(name: "Custom url redirects", description: "Coming soon", enabled: false),
        Feature.new(name: "API access", description: "Coming soon", enabled: false)
      ]
    elsif base?
      [
        Feature.new(name: "Unlimited notes pages", description: "No limit for the number of note pages", enabled: true),
        Feature.new(name: "Account Link", description: "Easily share the currently scheduled note with one link",
          enabled: true),
        Feature.new(name: "Schedule notes in advance",
          description: "Use the scheduler to schedule notes to go live in the future", enabled: true),
        Feature.new(name: "Download notes", description: "Download note pages from the editor", enabled: false),
        Feature.new(name: "Analytics", description: "Track note views, emails, downloads and more", enabled: true),
        Feature.new(name: "Engagement Tracking", description: "See who in your ministry is viewing the note pages",
          enabled: true),
        Feature.new(name: "Remove NotesPro branding", description: "Upload your own logo and hide NotesPro logos",
          enabled: true)
      ]
    elsif free?
      [
        Feature.new(name: "Up to 10 note pages", description: "", enabled: true),
        Feature.new(name: "Schedule notes in advance",
          description: "Use the scheduler to schedule notes to go live in the future", enabled: true),
        Feature.new(name: "Download notes", description: "Download note pages from the editor", enabled: false)
      ]
    end
  end

  def ensure_external_user_for(email:)
    user = users.find_by(email:)

    unless user
      user = User.new(email:, organization: self)
      user.save! validate: false
      user.organizations << self
    end

    user
  end

  def to_param
    alt_id
  end

  Feature = Struct.new :name, :description, :enabled, keyword_init: true

  private

  def set_encoded_name
    encoded_name = Organization.encode_name(name)
  end
end
