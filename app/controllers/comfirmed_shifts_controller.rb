class ComfirmedShiftsController < ApplicationController
    before_action :logged_in_staff
    #確定済みの各従業員のシフトを表示
    def index
        #このページで全てのアクションを実行していく
        @events = current_staff.individual_shifts.where(temporary: true).where(deletable: false)
    end
end
