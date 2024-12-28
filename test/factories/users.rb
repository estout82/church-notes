FactoryBot.define do
  factory :user do
    email { "test#{SecureRandom.hex 10}@test.com" }
    first_name { "Jim" }
    last_name { "Bob" }
    password { "1234" }
    password_confirmation { "1234" }
    time_zone { "America/New_York" }

    factory :user_in_main_account do
      after :create do |user|
        org = create :organization

        user.organizations << org
        account = org.main_account
        member = create :user_account_member, user:, account:, is_default: true
        create :user_account_member_role, user_account_member: member, role: :owner
      end
    end
  end
end
