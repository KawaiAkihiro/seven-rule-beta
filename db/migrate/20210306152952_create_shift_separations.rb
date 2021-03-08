class CreateShiftSeparations < ActiveRecord::Migration[6.1]
  def change
    create_table :shift_separations do |t|
      t.string :name
      t.time :start_time
      t.time :finish_time
      t.references :master, null: false, foreign_key: true

      t.timestamps
    end
  end
end
