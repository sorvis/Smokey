class TemperatureReading < ActiveRecord::Base

  def fahrenheit
    9.0/5.0*CelsiusReading + 32
  end

end
