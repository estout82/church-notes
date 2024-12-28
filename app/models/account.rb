class Account < ApplicationRecord
  belongs_to :organization
  belongs_to :subscription, optional: true
  belongs_to :parent_account, class_name: "Account", optional: true

  has_many :notes, dependent: :destroy
  has_many :schedules, dependent: :destroy

  has_many :members,
    class_name: "UserAccountMember",
    dependent: :destroy

  has_many :sub_accounts,
    class_name: "Account",
    foreign_key: :parent_account_id,
    dependent: :destroy

  has_many :users, through: :members

  has_one_attached :logo

  validates :name, presence: true

  before_create { self.alt_id = SecureRandom.alphanumeric(10).downcase }

  delegate :plan_name, to: :organization

  store_accessor :settings, :link_redirects, :primary_note_id

  def main?
    is_main?
  end

  def can_have_sub_accounts?
    can_have_sub_accounts
  end

  def sub_accounts?
    sub_accounts.present?
  end

  def add_member(user:, roles: [])
    UserAccountMember.transaction do
      member = UserAccountMember.create(
        user:,
        account: self
      )

      roles.each do |role|
        UserAccountMemberRole.create!(
          user_account_member: member,
          role:
        )
      end

      member
    end
  end

  def sub_accounts
    organization
      .accounts
      .where(parent_account: self)
  end

  def owners
    members.filter do |member|
      roles = member.roles.pluck(:role)
      roles.include?("owner")
    end
  end

  def plan
    organization.plan.to_sym
  end

  def main_account
    if main?
      self
    else
      organization.accounts.where(is_main: true).first
    end
  end

  def can_be_destroyed?
    return true if subscription.blank?

    !sub_accounts? && (
      (
        subscription.accounts.size == 1 &&
        subscription.accounts.first == self &&
        subscription.origin_account == self
      ) ||
      (
        subscription.origin_account != self
      )
    )
  end

  def teardown
    # fully destroys an account and all related data

    return false unless can_be_destroyed?

    subscription_handled = if subscription.present? && subscription.origin_account == self
      # subscription is attached to this account, fully delete it

      Stripe::Subscription.delete subscription.stripe_subscription_id
      old_subscription = subscription
      update! subscription: nil
      old_subscription.destroy
      true

    elsif subscription.present?
      # subscription is not attached to this account, just remove a sub account

      subscription
        .stripe_wrapper
        .remove_sub_account

    end

    destroy && subscription_handled
  end

  def link_redirects?
    !!link_redirects == true
  end

  def redirect_note
    live_notes = LiveNoteDecider.new(account: self).run

    return nil if live_notes.blank?

    primary_note = live_notes.find { |note| note.id == primary_note_id.to_i }
    primary_note.presence || live_notes.first
  end

  def parent_account_name
    if main? || parent_account.blank?
      organization.name
    else
      parent_account.name
    end
  end

  def external_name
    is_main ? organization.name : name
  end

  def onboarding
    Accounts::Onboarding.new account: self
  end

  def to_param
    alt_id
  end
end
