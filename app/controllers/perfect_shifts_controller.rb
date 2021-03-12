class PerfectShiftsController < ApplicationController
    def index
        #このページで全てのアクションを起こす
        if logged_in? && logged_in_staff?
            @events = current_master.individual_shifts.where(Temporary: true)
            @shift_separation = current_master.shift_separations.all
        elsif logged_in_staff? && !logged_in?
            @master = current_staff.master
            @events = @master.individual_shifts.where(Temporary: true)
            @shift_separation = @master.shift_separations.all
        elsif logged_in? && !logged_in_staff?
            @events = current_master.individual_shifts.where(Temporary: true)
            @shift_separation = current_master.shift_separations.all
        end
      end
    
      #終日予定を追加するmodalを表示
      def new_plan
        if logged_in?
          @event = current_master.individual_shifts.new
          return_html("form_new_plan")
        else
          return_html("alert")
        end
      end
    
      #終日予定を追加処理
      def create_plan
        @event = current_master.individual_shifts.new(params_plan)
        @event.staff = current_master.staffs.find_by(staff_number: 0)
        @event.Temporary = true
        @event.save
        respond_to do |format|
          format.html { redirect_to temporary_shifts_path }
          format.js
        end
      end
    
      #空きシフトを埋めるmodalを表示
      def fill
        #両方ログイン中
        if logged_in? && logged_in_staff?
          fill_form_master
    
        #従業員のみログイン時
        elsif !logged_in? && logged_in_staff?
          @event = current_staff.master.individual_shifts.find(params[:shift_id])
          @already_event = current_staff.individual_shifts.find_by(start: @event.start)
          #シフトが重複しない用にする
          if @already_event.nil?
            return_html("form_fill")
          else
            return_html("alert")
          end
    
        #店長のみログイン時
        elsif logged_in? && !logged_in_staff?
          fill_form_master
        
        end
      end
    
      #空きシフトを埋める処理
      def fill_in
        #両方ログイン中
        if logged_in? && logged_in_staff?
          #従業員を店長に設定
          fill_in_master
    
        #従業員のみログイン時
        elsif !logged_in? && logged_in_staff?
          #ログイン中の従業員が空きシフトを埋める
          @master = current_staff.master
          @event = @master.individual_shifts.find(params[:id])
          @event.staff = current_staff
    
        #店長のみログイン時
        elsif logged_in? && !logged_in_staff?  
          #従業員を店長に設定
          fill_in_master
        end
        
        @event.save
      end
    
      #シフトの変更のmodalを表示
      def change
        begin
          #両方ログイン時
          if logged_in? && logged_in_staff?
            @event = current_master.individual_shifts.find(params[:shift_id])
            #終日の予定をクリックした時
    
            masters_action
    
          #従業員のみログイン時
          elsif !logged_in? && logged_in_staff?
            @event = current_staff.master.individual_shifts.find(params[:shift_id])
            @already_event = current_staff.individual_shifts.find_by(start: @event.start)
            #終日判定
            unless @event.allDay
              #他人のシフトをクリック
              if @event.staff != current_staff 
                #シフト重複を避ける
                if @already_event.present?
                  return_html("alert")
                else
                  #モードによってmodalのhtmlを変更する
                  change_modal('form_instead', 'alert', 'alert')
                end
                
              # 自分の予定の場合
              elsif @event.staff == current_staff
                #モードによってmodalのhtmlを変更する
                change_modal('form_delete','already_delete', "already_instead")
              end
            else
              return_html("alert")
            end
    
          #店長のみログイン時
          elsif logged_in? && !logged_in_staff?
            @event = current_master.individual_shifts.find(params[:shift_id])
            #終日の予定をクリックした時
    
            masters_action
          end
        rescue => exception
          #何もしない(祝日イベント対策)
        end
        
      end
    
      #交代申請処理
      def instead
        #シフトのモードを変更、通知を作成、メール送信
        notice("instead")
      end
    
      #削除申請処理
      def delete
        #シフトのモードを変更、通知を作成、メール送信
        notice("delete")
      end
    
      private
    
        #店長ログイン時の空きシフトに入るためのmodal
        def fill_form_master
          @event = current_master.individual_shifts.find(params[:shift_id])
          #重複を避ける
          @master_staff = current_master.staffs.find_by(staff_number: current_master.staff_number)
          @already_event = @master_staff.individual_shifts.where(start:@event.start)
          unless @already_event.present?
            return_html("form_fill")
          else
            return_html("alert")
          end
        end
    
        #空きシフトに店長が入る処理
        def fill_in_master
          @event = current_master.individual_shifts.find(params[:id])
          @event.staff = current_master.staffs.find_by(staff_number:current_master.staff_number)
        end
    
        #変更に関して店長ができることを表示する
        def masters_action
          unless @event.allDay
            #店長権限でシフトをダイレクトに削除する
            return_html("form_direct_delete")
          else
            return_html("plan_delete")
          end
        end
    
        def params_notice
          params.require(:individual_shift).permit(:comment)
        end
    
        def params_plan
          params.require(:individual_shift).permit(:plan, :start)
        end
    
        #シフトのモードを変更、通知を作成、メール送信
        def notice(mode)
          @master = current_staff.master
    
          @event = @master.individual_shifts.find(params[:id])
          @event.mode = mode
          @event.save
    
          #通知を作成
          @notice = @master.notices.new
          @notice.mode = mode
          @notice.staff_id = current_staff.id
          @notice.shift_id = @event.id
          @notice.save
    
          #メール機能がオンなら通知を送信
          if @master.onoff_email
          NoticeMailer.send_when_create_notice(@notice).deliver
          end
        end
    
        #シフトのmodeによって表示するmodalを変更する
        def change_modal(nil_html,delete,instead)
          if @event.mode.nil?
            return_html(nil_html)
          elsif @event.mode == "delete"
            return_html(delete)
          elsif @event.mode == "instead"
            return_html(instead)
          end
        end
end
