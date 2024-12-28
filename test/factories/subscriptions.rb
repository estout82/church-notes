FactoryBot.define do
  factory :subscription do
    stripe_subscription_id { SecureRandom.hex 12 }
  end
end