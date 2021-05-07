class ChangeDataStructureMastersFinish < ActiveRecord::Migration[6.1]
  def change
    change_column :masters, :submits_finish, :date
  end
end
