class AddDeviceIdToTemperatureReadings < ActiveRecord::Migration
  def change
    add_column :temperature_readings, :device_id, :integer
  end
end
