class CreatePatterns < ActiveRecord::Migration[6.1]
  def change
    create_table :patterns do |t|
      t.time :start
      t.time :finish
      t.references :staff, null: false, foreign_key: true

      t.timestamps
    end
  end
end
