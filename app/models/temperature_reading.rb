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

  def self.get_summary
    readings = TemperatureReading.group_by_hour(:created_at).average(:CelciusReading)
    readings.update(readings) {|time, celcius| TemperatureReading.toFahrenheit(celcius)} 
  end

end
