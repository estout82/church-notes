FactoryBot.define do
  factory :account do
    association :organization, factory: :organization
    association :subscription, factory: :subscription

    name { "Test Account #{SecureRandom.hex 4}" }
    is_main { false }
    can_have_sub_accounts { true }

    factory :main_account do
      is_main { true }
    end
  end
end