#
# Handles webhooks from Stripe
#
# TODO handle tearing down accounts when Stripe says sub goes in-active
#

require "stripe"

class StripeController < ApplicationController
  include Loggable

  skip_before_action :verify_authenticity_token, only: :webhook

  def webhook
    signature_header = request.env["HTTP_STRIPE_SIGNATURE"]
    webhook_secret = ENV["NOTESPRO_STRIPE_WEBHOOK_SECRET"]

    event = Stripe::Webhook.construct_event(
      request.body.read,
      signature_header,
      webhook_secret
    )

    type = event[:type]
    data = event.data.object

    case type
    when "invoice.payment_failed"
    when "invoice.upcoming"
    when "invoice.payment_succeeded"
    when "customer.subscription.created"
      if data.metadata[:sub_account_only] == "true"
        log "sub account only purchase"
        head :no_content
        return
      end

      organization = Organization.find_by id: data.metadata[:organization_id]

      raise MissingOrganizationError if organization.blank?
      raise MissingMainAccountError if organization.main_account.blank?
      raise ExistingSubscriptionError if organization.main_account.subscription.present?

      # create subscription
      app_status = data.status == "active" ? :active : :inactive

      subscription = Subscription.create!(
        stripe_subscription_id: data.id,
        stripe_customer_id: data.customer,
        status: app_status,
        origin_account: organization.main_account
      )

      organization.main_account.update!(subscription:)

    when "customer.subscription.updated"
      organization = Organization.find_by id: data.metadata[:organization_id]

      if data.metadata[:sub_account_only] == "true" && data.status == "active"
        # handle a sub account only subscription purchase

        if Subscription.find_by(stripe_subscription_id: data.id).present?
          # NOTE: Check to see if the subscription has been created. This would
          # indicate that this sub account subscription has already been
          # processed and we should skip it.

          render json: { error: "Subscription already exists" }, status: :bad_request
          return
        end

        name = data.metadata[:sub_account_name]
        parent_account = Account.find(data.metadata[:parent_account_id])
        purchaser = User.find(data.metadata[:purchaser_id])

        ActiveRecord::Base.transaction do
          subscription = Subscription.create!(
            stripe_subscription_id: data.id,
            stripe_customer_id: data.customer,
            status: data.status == "active" ? :active : :inactive
          )

          account = Account.create!(
            organization:,
            is_main: false,
            subscription:,
            parent_account:,
            name:
          )

          purchaser.add_account_membership account, :owner

          subscription.update!(origin_account: account)
        end

        head :created

        return
      end

      raise MissingOrganizationError if organization.blank?
      raise MissingMainAccountError if organization.main_account.blank?
      raise MissingSubscriptionError if organization.main_account.subscription.blank?

      # TODO: handle subaccount stuff here

      if data.status == "active"
        subscription = Subscription.find_by stripe_subscription_id: data.id

        if subscription.present?
          subscription.update status: :active

          if organization.multisite?
            # TODO: handle cases where purchased subaccounts is different than
            # what Stripe is telling us

            sub_account_quantity = data
              .items
              .find { |item| item.price.id == Constants::Billing::SUBACCOUNT_PRICE_ID }
              &.quantity

            raise MissingSubAccountQuantityError if sub_account_quantity.blank?

            subscription.update purchased_sub_accounts: sub_account_quantity
          end
        else
          raise MissingSubscriptionError
        end
      end
    end
  end

  #
  # Raised if an incoming subscription webhook does not contain a valid
  # organization_id in the metadata
  #
  class MissingOrganizationError < StandardError; end

  #
  # Raised if the organization included in the webhook does not have
  # a main account
  #
  class MissingMainAccountError < StandardError; end

  #
  # Raised if the main_account attached to the organization from the webhook
  # already has a subscription set up.
  #
  # REFACTOR this will change in the future, but just scoping this down to
  # disallow multiple subscriptions for now
  #
  class ExistingSubscriptionError < StandardError; end

  #
  # Raised if the main_account attached to the organization from the webhook
  # does not have a subscription record in-app (and is required to)
  #
  class MissingSubscriptionError < StandardError; end

  #
  # Raised if a subscription.updated webhook is received for a multisite
  # organization and the webhook does not include an item for subaccounts.
  #
  class MissingSubAccountQuantityError < StandardError; end
end
