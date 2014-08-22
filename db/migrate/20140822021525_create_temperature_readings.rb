class CreateTemperatureReadings < ActiveRecord::Migration
  def change
    create_table :temperature_readings do |t|
      t.decimal :CelciusReading

      t.timestamps
    end
  end
end
