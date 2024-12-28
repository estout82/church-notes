#
# Allows the user to manage billing for the organization
#

class Organization::BillingController < ApplicationController
  include Loggable

  before_action :require_login!
  before_action :set_organization
  before_action :require_permission!
  before_action { @current_page = :organization_billing }

  def show
    @account = current_account
    @subscription = @account.subscription

    # subscription cannot be nil
    if @subscription.blank?
      log "subscription is blank"

      render :error
      return
    end

    # subscription must contain all information required for stripe request
    unless @subscription.useable?
      log "subscription is not usable"

      render :error
      return
    end

    begin
      @stripe_subscription = Stripe::Subscription.retrieve({
        id: @account
          .subscription
          .stripe_subscription_id,
        expand: ["latest_invoice"]
      })
    rescue Stripe::InvalidRequestError
      log "subscription does not exist in stripe"

      render :error
      return
    end

    @stripe_next_invoice = Stripe::Invoice.upcoming({
      subscription: @account
        .subscription
        .stripe_subscription_id
    })

    @wrapper = Billing::StripeSubscriptionWrapper.new @stripe_subscription

    portal_session = Stripe::BillingPortal::Session.create({
      customer: @account.subscription.stripe_customer_id,
      return_url: settings_account_url,
    })

    @manage_billing_url = portal_session.url
  end

  private

  #
  # actions
  #

  def set_organization
    @organization = current_account.organization
  end

  def require_permission!
    has_billing_permission = current_user.permissions.for_account?(
      @organization.main_account,
      :billing
    )

    unless has_billing_permission
      toast(
        "Sorry, you're not allowed to do that",
        status: :forbidden
      )
    end
  end
end
