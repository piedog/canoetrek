class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.string :description
      t.point :center, :geographic => true
      t.integer :zoom
      t.integer :user_id

      t.timestamps
    end

    add_index :trips, [:user_id]
  end
end
