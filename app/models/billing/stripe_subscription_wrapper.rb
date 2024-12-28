#
# Wraps a Stripe::Subscription object to make it more usable
#

class Billing::StripeSubscriptionWrapper
  def initialize(subscription)
    @subscription = subscription

    @product_ids = subscription
      .items
      .data
      .map(&:price)
      .map(&:product)
  end

  def real_plan_string
    if multisite?
      "NotesPro Multi-Site"
    elsif base?
      "NotesPro Base"
    elsif free?
      "NotesPro Free"
    elsif sub_account?
      "NotesPro Sub Account"
    end
  end

  def plan_price
    if multisite?
      149
    elsif base?
      29
    elsif free?
      0
    elsif sub_account?
      9
    end
  end

  def sub_account_quantity
    item = @subscription
      .items
      .data
      .find { |item| item.price.id == Constants::Billing::SUBACCOUNT_PRICE_ID }

    if item.present?
      item.quantity
    end
  end

  def add_sub_account
    item = @subscription
      .items
      .data
      .find { |item| item.price.id == Constants::Billing::SUBACCOUNT_PRICE_ID }

    update_payload = if item.present?
      updated = Stripe::Subscription.update(
        @subscription.id,
        {
          items: [
            {
              id: item.id,
              quantity: (item.quantity + 1)
            }
          ]
        }
      )
  
      updated_item = updated
        .items
        .data
        .find { |item| item.price.id == Constants::Billing::SUBACCOUNT_PRICE_ID }
  
      updated_item.quantity > item.quantity
    else
      new_item = Stripe::SubscriptionItem.create({
        subscription: @subscription.id,
        quantity: 1,
        price: Constants::Billing::SUBACCOUNT_PRICE_ID
      })

      new_item.id.present?
    end
  end

  def remove_sub_account
    item = @subscription
      .items
      .data
      .find { |item| item.price.id == Constants::Billing::SUBACCOUNT_PRICE_ID }

    updated = Stripe::Subscription.update(
      @subscription.id,
      {
        items: [
          {
            id: item.id,
            quantity: (item.quantity > 1 ? item.quantity - 1 : 0)
          }
        ]
      }
    )

    updated_item = updated
      .items
      .data
      .find { |item| item.price.id == Constants::Billing::SUBACCOUNT_PRICE_ID }

    updated_item.quantity < item.quantity || updated_item.quantity == 0
  end

  private

  def free?
    @product_ids.include? Constants::Billing::FREE_PRODUCT_ID
  end

  def base?
    @product_ids.include? Constants::Billing::BASE_PRODUCT_ID
  end

  def multisite?
    @product_ids.include? Constants::Billing::MULTISITE_PRODUCT_ID
  end

  def sub_account?
    !free? &&
      !base? &&
      !multisite? &&
      @product_ids.include?(Constants::Billing::SUB_ACCOUNT_PRODUCT_ID)
  end
end