json.array!(@temperature_readings) do |temperature_reading|
  json.extract! temperature_reading, :id, :CelciusReading
  json.url temperature_reading_url(temperature_reading, format: :json)
end
