FactoryBot.define do
  factory :interaction do
    association :user, factory: :user

    factory :generic_interaction, class: "interactions/generic" do
    end

    factory :note_view_interaction, class: "interactions/note_view" do
    end
  end
end
