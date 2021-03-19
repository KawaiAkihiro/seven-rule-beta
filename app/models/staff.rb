class Staff < ApplicationRecord
  belongs_to :master
  has_many :individual_shifts , dependent: :destroy
  has_many :patterns, dependent: :destroy

  default_scope -> { order(staff_number: :asc) }
  validates :master_id,    presence: true
  validates :staff_name,   presence: true, uniqueness: true
  validates :staff_number, presence: true, uniqueness: true

  has_secure_password
  validates :password,   presence: true, length: { minimum: 4}, allow_nil: true
end
