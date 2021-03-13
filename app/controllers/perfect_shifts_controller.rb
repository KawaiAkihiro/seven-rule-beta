class PerfectShiftsController < ApplicationController
      def index
        #このページで全てのアクションを起こす
        if logged_in? && logged_in_staff?
            @events = current_master.individual_shifts.where(Temporary: true)
        elsif logged_in_staff? && !logged_in? 
            @events = current_staff.master.individual_shifts.where(Temporary: true)
        elsif logged_in? && !logged_in_staff?
            @events = current_master.individual_shifts.where(Temporary: true)
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
      end

      def new_shift
        @event = current_master.individual_shifts.new
        @separations = current_master.shift_separations.all
        #空きシフト追加modal用のhtmlを返す
        render plain: render_to_string(partial: 'form_new_shift', layout: false, locals: { event: @event, separations:@separations })
      end

      def create_shift
        @event = current_master.individual_shifts.new(params_shift)
        change_finishDate
        @event.staff = current_master.staffs.find_by(staff_number: 0)
        @event.Temporary = true
        unless @event.save
          render partial: "individual_shifts/error"
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

          fill_in_master
    
        #従業員のみログイン時
        elsif !logged_in? && logged_in_staff?

          @master = current_staff.master
          @event = @master.individual_shifts.find(params[:id])
          @event.staff = current_staff
    
        #店長のみログイン時
        elsif logged_in? && !logged_in_staff?  

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
                  return_html('form_instead')
                end
                
              # 自分の予定の場合
              elsif @event.staff == current_staff
                return_html("alert")
              end
            else
              return_html("alert")
            end
    
          #店長のみログイン時
          elsif logged_in? && !logged_in_staff?
            @event = current_master.individual_shifts.find(params[:shift_id])
            masters_action
          end
        rescue => exception
          #何もしない(祝日イベント対策)
        end
        
      end
    
      #交代処理
      def instead
        @shift  = current_staff.master.individual_shifts.find(params[:id])
        @shift.staff = current_staff
        @shift.save
      end
    
      private
    
        #店長ログイン時の空きシフトに入るためのmodal
        def fill_form_master
          @event = current_master.individual_shifts.find(params[:shift_id])
          #重複を避ける
          return_html("form_fill")
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

        def params_shift
          params.require(:individual_shift).permit(:start, :finish)
        end
    
        def params_plan
          params.require(:individual_shift).permit(:plan, :start)
        end
end
