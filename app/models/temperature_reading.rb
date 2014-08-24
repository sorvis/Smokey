class TemperatureReading < ActiveRecord::Base

  def fahrenheit
    9.0 / 5.0 * self.CelciusReading + 32
  end

end
