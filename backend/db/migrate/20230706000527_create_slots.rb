class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots, id: false do |t|
      t.string :id, null: false
      t.timestamp :start_time, null: false, index: true
      t.timestamp :end_time, null: false, index: true
      t.timestamps 
    end

    add_index :slots, :id, unique: true
    add_index :slots, [:start_time, :end_time], unique: true
  end
end
