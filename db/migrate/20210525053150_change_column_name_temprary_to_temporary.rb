class ChangeColumnNameTempraryToTemporary < ActiveRecord::Migration[6.1]
  def change
    rename_column :individual_shifts, :Temporary, :temporary
  end
end
