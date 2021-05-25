class RenameColumnNumberAndName < ActiveRecord::Migration[6.1]
  def change
    rename_column :staffs, :staff_name, :name
    rename_column :staffs, :staff_number, :number
  end
end
