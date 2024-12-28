FactoryBot.define do
  factory :user_account_member_role do
    association :user_account_member, factory: :user_account_member
    role { :owner }
  end
end