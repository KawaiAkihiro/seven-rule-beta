class ComfirmedShiftsController < ApplicationController
    #確定済みの各従業員のシフトを表示
    def index
        #このページで全てのアクションを実行していく
        @events = current_staff.individual_shifts.where(Temporary: true).where(deletable: false)
    end
end
