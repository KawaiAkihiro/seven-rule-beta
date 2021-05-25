class Staff < ApplicationRecord
  belongs_to :master
  has_many :individual_shifts , dependent: :destroy
  has_many :patterns, dependent: :destroy

  default_scope -> { order(number: :asc) }
  validates :master_id,    presence: true
  validates :name,   presence: true
  validates :number, presence: true

  has_secure_password
  validates :password,   presence: true, length: { minimum: 4}, allow_nil: true
end
