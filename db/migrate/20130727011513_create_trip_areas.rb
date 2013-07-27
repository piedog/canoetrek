class CreateTripAreas < ActiveRecord::Migration
  def change
    create_table :trip_areas do |t|
      t.string :name
      t.string :description
      t.point :center_point, :geographic => true
      t.integer :zoom_level
      t.integer :user_id

      t.timestamps
    end
    add_index :trip_areas, [:user_id, :created_at]
  end
end
