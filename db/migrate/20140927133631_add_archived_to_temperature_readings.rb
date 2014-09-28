class AddArchivedToTemperatureReadings < ActiveRecord::Migration
  def change
    add_column :temperature_readings, :archived, :boolean, default: false
  end
end
