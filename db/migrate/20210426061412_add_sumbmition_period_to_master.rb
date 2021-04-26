class AddSumbmitionPeriodToMaster < ActiveRecord::Migration[6.1]
  def up
    add_column :masters, :submits_start, :datetime, default: nil,  null: nil
    add_column :masters, :submits_finish, :datetime, default: nil, null: nil
  end

  def down
    remove_column :masters, :submits_start, :datetime, default: nil,  null: nil
    remove_column :masters, :submits_finish, :datetime, default: nil, null: nil
  end
end
