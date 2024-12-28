FactoryBot.define do
  factory :organization do
    sequence(:name) { |_n| "Test Organization #{SecureRandom.hex 10}" }
    sequence(:encoded_name) { |_n| "testorganization#{SecureRandom.hex 10}" }
    plan { :no_plan }

    after :create do |organization|
      create(:main_account, organization:)
    end

    factory :free_organization do
      plan { :free }
    end

    factory :base_organization do
      plan { :base }
    end

    factory :multisite_organization do
      plan { :multisite }
    end
  end
end
