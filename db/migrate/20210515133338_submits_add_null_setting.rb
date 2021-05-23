class SubmitsAddNullSetting < ActiveRecord::Migration[6.1]
  def up
    change_column :masters, :submits_start, :date,  null:true
    change_column :masters, :submits_finish, :date, null:true
  end

  def down
    change_column :masters, :submits_start, :date,  null:false
    change_column :masters, :submits_finish, :date, null:false
  end
end
