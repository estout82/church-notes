FactoryBot.define do
  factory :note_instance_fill_in, class: "notes/instances/fill_in" do
    association :instance, factory: :note_instance

    guid { SecureRandom.hex(10) }
    value { "Test Fill In Value" }
  end
end
