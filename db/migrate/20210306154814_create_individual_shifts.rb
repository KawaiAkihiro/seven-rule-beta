class CreateIndividualShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :individual_shifts do |t|
      t.datetime :start
      t.datetime :finish
      t.boolean :Temporary
      t.boolean :deletable
      t.string :mode
      t.string :plan
      t.references :staff, null: false, foreign_key: true

      t.timestamps
    end
  end
end
