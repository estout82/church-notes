FactoryBot.define do
  factory :user_account_member do
    association :user, factory: :user
    association :account, factory: :account
  end
end