# frozen_string_literal: true

# You know what a User is
class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :organization_members, dependent: :destroy
  has_many :organizations, through: :organization_members
  has_many :tokens, dependent: :destroy
  has_many :user_account_members, dependent: :destroy
  has_many :accounts, through: :user_account_members
  has_many :interactions, dependent: :destroy
  has_many :note_instances, dependent: :destroy
  has_many :messages, -> { order(created_at: :desc) }, as: :recipient, dependent: :destroy

  has_many :sent_messages,
    -> { order(created_at: :desc) },
    dependent: :destroy,
    class_name: "Message",
    foreign_key: :sender_id

  has_secure_password

  validates :email, presence: true

  validates :email,
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "Email is invalid"
    },
    allow_blank: true

  # Internal users are members of accounts with permissions
  scope :internal, -> { joins(:user_account_members) }

  scope :with_messages, -> { includes(:messages) }
  scope :with_full_messages, -> { includes(messages: [:messages, :context]) }

  def full_name
    "#{first_name.presence || ''} #{last_name.presence || ''}"
  end

  def permissions
    Permissions.new self
  end

  def add_account_membership(account, roles)
    roles = [roles] unless roles.instance_of? Array

    ActiveRecord::Base.transaction do
      member = UserAccountMember.create!(
        user: self,
        account:,
        is_default: false
      )

      roles.each do |role|
        role_sym = role.to_sym

        # TODO: check security

        UserAccountMemberRole.create!(
          user_account_member: member,
          role: role_sym
        )
      end

      member
    end
  end

  def default_account
    member = user_account_members.find_by(is_default: true) || user_account_members.first
    member&.account
  end

  def default_organization
    organizations.last # IE most recent
  end

  def default_account?
    default_account.present?
  end

  # returns true or false weather of not this user has the desired permission
  # on provided account
  def account_permission?(account, permission)
    return false if account.nil?

    user_account_member = account_membership(account:)

    unless user_account_member.nil?
      roles = user_account_member.roles

      return true if permission == :any and roles.where.not(role: :no_role).exists?

      # owners can do everything
      return true if roles.where(role: :owner).exists?

      # admins can do everything except billing
      return true if roles.where(role: :admin).exists? and permission != :billing and permission != :owner

      return true if permission == :billing and roles.where(role: :billing).exists?

      return true if permission == :scheduling and roles.where(role: :scheduling).exists?

      return true if permission == :editor and roles.where(role: :editor).exists?
    end

    false
  end

  def account_membership(account:)
    user_account_members
      .find_by(account:)
  end

  def last_interaction
    interactions
      .order(created_at: :desc)
      .first
  end

  def active?
    true
  end

  def external_only?
    accounts.empty?
  end

  def best_root_path
    if external_only?
      external_organization_path(default_organization.encoded_name)
    else
      root_path
    end
  end

  def current_follow_up_for(note:)
    messages
      .where(context: note.actions)
      .limit(1)
      .first
  end

  def previous_follow_ups_for(note:)
    messages
      .where(context: note.actions)
      .offset(1)
  end
end
