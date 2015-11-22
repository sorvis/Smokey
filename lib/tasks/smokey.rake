namespace :smokey do
  desc "Archive readings before today"
  task archive: :environment do
    TemperatureReading.archive!
  end

  desc "Delete readings older then 180 days"
  task delete_old_data: :environment do
    TemperatureReading.DeleteOlderThenDays 180
  end

end
