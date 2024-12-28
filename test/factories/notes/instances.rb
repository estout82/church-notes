FactoryBot.define do
  factory :note_instance, class: "notes/instance" do
    association :note, factory: :note
    association :user, factory: :database_external_user
  end
end
