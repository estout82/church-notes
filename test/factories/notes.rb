FactoryBot.define do
  factory :note do
    association :account, factory: :account
    title { "Test Note" }
    background_color { "#ffffff" }
  end
end