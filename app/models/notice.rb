class Notice < ApplicationRecord
  belongs_to :master
  default_scope -> { order(created_at: :desc) }
end
