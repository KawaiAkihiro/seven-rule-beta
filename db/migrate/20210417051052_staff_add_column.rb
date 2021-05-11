class StaffAddColumn < ActiveRecord::Migration[6.1]
  def up
    add_column :staffs, :abandon, :boolean, default: false, null: false
  end

  def down
    remove_column :staffs, :abandon, :boolean, default: false, null: false
  end
end
