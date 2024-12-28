FactoryBot.define do
  factory :schedule do
    association :note, factory: :note

    start_at { Time.current.utc }
    end_at { Time.current.utc + 1.day }

    after :build do |schedule|
      schedule.account = schedule.note.account if schedule.account.blank?
    end
  end
end
