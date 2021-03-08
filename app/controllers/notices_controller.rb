class NoticesController < ApplicationController
    before_action :logged_in_master

    def index
        #通知一覧
        @notices = current_master.notices.all
    end
    
    #申請を承認する
    def update
        @notice = current_master.notices.find(params[:id])
        @shift  = current_master.individual_shifts.find(@notice.shift_id)
        #htmlで使用
        @old_staff = @shift.staff

        #申請の種類によって変更する人を選択する
        if @notice.mode == "instead"
            @new_staff = current_master.staffs.find(@notice.staff_id)
        elsif @notice.mode == "delete"
            @new_staff = current_master.staffs.find_by(staff_number:0)
        end

        #人を変更し、状態を元に戻して保存
        @shift.staff = @new_staff
        @shift.mode = nil
        @shift.save

        #通知は破棄して更新
        @notice.destroy!
        flash[:success] = "申請を反映しました！"
        redirect_to notices_path
    end


    #申請を拒否する
    def destroy
        #通知を破棄し、シフトの状態を元に戻して更新
        @notice = current_master.notices.find(params[:id]).destroy!
        @shift  = current_master.individual_shifts.find(@notice.shift_id)
        @shift.mode = nil
        @shift.save
        flash[:danger] = "申請を拒否したので変更はありません"
        redirect_to notices_path
    end
end
