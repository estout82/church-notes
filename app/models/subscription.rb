
class Subscription < ApplicationRecord
  has_many :accounts

  belongs_to :origin_account,
    class_name: "Account",
    optional: true

  enum :status, {inactive: 0, active: 1}

  def useable?
    active? &&
      stripe_subscription_id.present? &&
      stripe_customer_id.present?
  end

  def main?
    #
    # Returns true if the subscription is the subscription
    # attached to the main account of the organization
    #

    self
      .accounts
      .where(is_main: true)
      .exists?
  end

  def billed_sub_accounts
    #
    # Returns each account this subscription is responsible for billing
    #

    if main?
      self
        .accounts
        .where(subscription: self)
        .where(is_main: false)
    else
      Account.none
    end
  end

  def stripe_wrapper
    # TODO rescue stripe API error

    Billing::StripeSubscriptionWrapper.new(
      Stripe::Subscription.retrieve(
        stripe_subscription_id
      )
    )
  end
end
