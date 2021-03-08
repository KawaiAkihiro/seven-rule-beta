class Master < ApplicationRecord
    has_many :staffs, dependent: :destroy
    has_many :shift_separations, dependent: :destroy
    has_many :individual_shifts, through: :staffs
    has_many :notices

    attr_accessor :remember_token 
    validates :store_name, presence: true, length: { maximum: 20}, uniqueness: true
    validates :user_name,  presence: true, length: { maximum: 20}

    has_secure_password
    validates :password,   presence: true, length: { minimum: 6}, allow_nil: true

    
    def Master.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    #新しいトークンを発行
    def Master.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = Master.new_token
        update_attribute(:remember_digest, Master.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end
