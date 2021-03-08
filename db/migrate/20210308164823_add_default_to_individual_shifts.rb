class AddDefaultToIndividualShifts < ActiveRecord::Migration[6.1]
  def change
    change_column :individual_shifts, :deletable, :boolean, default: false, null: false
    change_column :individual_shifts, :Temporary, :boolean, default: false, null: false
  end
end
