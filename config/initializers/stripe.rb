#
# Initializes the Stripe integration
#

if Rails.env.test?
  Rails.configuration.stripe = {
    publishable_key: "pk_1234",
    secret_key: "sk_1234"
  }
  
  Stripe.api_key = "api_1234"
else
  Rails.configuration.stripe = {
    publishable_key: ENV["NOTESPRO_STRIPE_PK"],
    secret_key: ENV["NOTESPRO_STRIPE_SK"]
  }
  
  Stripe.api_key = ENV["NOTESPRO_STRIPE_SK"]  
end
