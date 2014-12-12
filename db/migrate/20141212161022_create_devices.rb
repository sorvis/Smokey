class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :external_id
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
