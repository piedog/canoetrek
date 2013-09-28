class CreateEnrollments < ActiveRecord::Migration
    def change
        create_table :enrollments do |t|
            t.integer :opentrip_id
            t.integer :participant_id

            t.timestamps
        end

        add_index :enrollments, :opentrip_id
        add_index :enrollments, :participant_id
        add_index :enrollments, [:opentrip_id, :participant_id], unique: true
    end
end
