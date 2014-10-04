namespace :smokey do
  desc "Archive readings before today"
  task archive: :environment do
    TemperatureReading.archive!
  end

end
