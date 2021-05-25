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
    validate :start_finish_check

    def start_finish_check
        errors.add("日付が間違っています。正しく記入してください。") if self.submits_start >= self.submits_finish
    end

    
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

    def submited_staff
        @no_staffs = []
        if self.shift_onoff
            @staffs = self.staffs.all
            master_staff_id = self.staff_number #店長の従業員番号
            @staffs.each do |staff|
                @shift = staff.individual_shifts.where(temporary: false)
                if (@shift.count != 0 || staff.abandon)&& staff.number != 0 && staff.number != master_staff_id 
                    @no_staffs.push(staff)
                end
            end
        end
        @no_staffs
    end

    def unsubmit_staff
        @no_staffs = []
        if self.shift_onoff
            @staffs = self.staffs.all
            master_staff_id = self.staff_number #店長の従業員番号
            @staffs.each do |staff|
                @shift = staff.individual_shifts.where(temporary: false)
                if @shift.count == 0 && staff.number != 0 && staff.number != master_staff_id
                    @no_staffs.push(staff)
                end
            end
        end
        @no_staffs
    end
end
