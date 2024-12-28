namespace :cleanup do
  desc "sets new account_id FK on existing schedules"
  task set_schedule_account_ids: :environment do
    Schedule.all.each do |schedule|
      schedule.update!(account: schedule.note.account)
    end
  end
end
