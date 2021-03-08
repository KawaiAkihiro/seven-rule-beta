class CreateMasters < ActiveRecord::Migration[6.1]
  def change
    create_table :masters do |t|
      t.string :store_name
      t.string :user_name
      t.string :password_digest
      t.string :remember_digest
      t.boolean :shift_onoff, default: false, null: false
      t.integer :staff_number
      t.string :email
      t.boolean :onoff_email, default: true, null: true

      t.timestamps
    end
  end
end
