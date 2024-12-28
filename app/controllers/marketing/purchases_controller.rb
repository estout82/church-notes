# frozen_string_literal: true

# Basically pushes new sign ups to slack
class Marketing::PurchasesController < ApplicationController
  layout "marketing"

  before_action :set_sign_up!, only: :show

  def show; end

  def create
    @sign_up = SignUp.new sign_up_params

    if @sign_up.save
      payload = {
        success_url: root_url(checkout_success: true),
        cancel_url: root_url,
        mode: "subscription",
        customer_email: @sign_up.email,
        subscription_data: {
          metadata: {
            plan: @sign_up.plan
          }
        },
        line_items: [
          {
            price: @sign_up.stripe_price_id,
            quantity: 1
          }
        ]
      }

      @stripe_session = Stripe::Checkout::Session.create(payload)

      Marketing::PostPurchaseJob.perform_later(sign_up: @sign_up)

      respond_to :turbo_stream
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_sign_up!
    @sign_up = SignUp.find_by alt_id: params[:alt_id]
  end

  def sign_up_params
    params
      .require(:sign_up)
      .permit(:first_name, :last_name, :email, :plan)
  end
end
