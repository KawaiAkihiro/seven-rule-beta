class AddColumnNextStaffIdToShift < ActiveRecord::Migration[6.1]
  def up
    add_column :individual_shifts, :next_staff_id, :integer, default: nil, null: nil
  end

  def down
    remove_column :individual_shifts, :next_staff_id, :integer, default: nil, null: nil
  end
end
