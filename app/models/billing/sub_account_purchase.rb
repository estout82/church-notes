#
# Represents the purchase of an additional sub account
#
class Billing::SubAccountPurchase
  include ActiveModel::Model

  attr_accessor :name,
    :billing,
    :organization,
    :subscription,
    :parent_account,
    :new_account,
    :stripe_subscription

  validates :name, presence: true
  validates :billing, presence: true

  def parent_billing?
    billing.to_sym == :parent
  end

  def sub_account_billing?
    billing.to_sym == :sub
  end

  def perform_stripe_setup(user:)
    #
    # Adds a new subscription for a sub account to the user's existing customer (or
    # creates a customer).
    #
    # NOTE in the future we may want to just add more sub accounts to an existing
    # subscription instead of creating a new subscription for each sub account
    #

    @customer = if user.stripe_customer_id.present?
                  Stripe::Customer.retrieve(user.stripe_customer_id)
                else
                  new_customer = Stripe::Customer.create email: user.email
                  user.update!(stripe_customer_id: new_customer.id)
                  new_customer
                end

    items = [
      {
        price: Constants::Billing::SUBACCOUNT_PRICE_ID,
        quantity: 1
      }
    ]

    @stripe_subscription = Stripe::Subscription.create(
      customer: @customer.id,
      metadata: {
        organization_id: organization.id,
        parent_account_id: parent_account.id,
        sub_account_only: true,
        sub_account_name: name,
        purchaser_id: user.id
      },
      items:,
      payment_behavior: "default_incomplete",
      payment_settings: {
        save_default_payment_method: "on_subscription"
      },
      expand: ["latest_invoice.payment_intent"]
    )
  end

  def perform_app_setup(user:)
    self.new_account = Account.create(
      organization:,
      subscription:,
      parent_account:,
      is_main: false,
      name:
    )

    user.add_account_membership new_account, :owner
  end
end
