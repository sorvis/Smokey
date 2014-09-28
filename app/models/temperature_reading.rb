class TemperatureReading < ActiveRecord::Base
  validates :CelciusReading, presence: true

  def fahrenheit
    return nil if self.CelciusReading.nil?
    TemperatureReading.toFahrenheit(self.CelciusReading)
  end

  def self.toFahrenheit(celcius)
    9.0 / 5.0 * celcius + 32
  end

  def self.latest
    TemperatureReading.last 
  end

  def self.get_summary(range = :all)
    case range
    when :today
      readings = TemperatureReading.group_by_hour(:created_at, 
        range: Date.today.beginning_of_day..Date.today.end_of_day).average(:CelciusReading)
    when :all
      readings = TemperatureReading.group_by_hour(:created_at).average(:CelciusReading)
    end
    readings.update(readings) {|time, celcius| TemperatureReading.toFahrenheit(celcius)} 
  end

  def self.archive!
    averaged = TemperatureReading.get_summary.
      reject{|time| time.to_date == Date.today}
    TemperatureReading.destroy_all{ created_at < DateTime.
                              today_beginning_of_day}
    averaged.each{|time, celcius| TemperatureReading.
                  create! :created_at => time, :CelciusReading => celcius}
  end

end
