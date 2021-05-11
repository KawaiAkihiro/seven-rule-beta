class ChangeDataStructureMasters < ActiveRecord::Migration[6.1]
  def change
    change_column :masters, :submits_start, :date
  end
end
