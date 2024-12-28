# frozen_string_literal: true

# Represents a user signing up via the external note page
class External::SignUp < ApplicationRecord
  self.table_name = :external_sign_ups

  attr_accessor :password, :password_confirmation

  belongs_to :organization

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email,
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "Email is invalid"
    },
    allow_blank: true

  validates :password,
    presence: true,
    length: { minimum: 10, maximum: 50 },
    confirmation: true,
    allow_nil: false,
    on: :new

  before_create { self.alt_id = SecureRandom.alphanumeric(24).downcase }

  def self.from_params(params, organization:)
    new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      interest_url: params[:interest_url],
      source: params[:source],
      organization:
    )
  end

  def provision
    return false unless valid? :new

    User.transaction do
      user = User.find_by(email:)

      if user.present? && !user.organizations.include?(organization)
        user.organizations << organization
        user.user_account_members.destroy_all unless user.active?
        user
      else
        provision_new_user
      end
    end
  end

  def success_message
    "Welcome, #{first_name}. Your account is all set up!"
  end

  private

  def provision_new_user
    user = User.create!(
      first_name:,
      last_name:,
      email:,
      password:,
      password_confirmation:
    )

    user.organizations << organization

    user
  end
end
