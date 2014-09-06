class TemperatureReading < ActiveRecord::Base
  validates :CelciusReading, presence: true

  def fahrenheit
    return nil if self.CelciusReading.nil?
    9.0 / 5.0 * self.CelciusReading + 32
  end

  def self.latest
    TemperatureReading.last 
  end

  def self.get_summary
    TemperatureReading.group_by_hour(:created_at).average(:CelciusReading)
  end

end
