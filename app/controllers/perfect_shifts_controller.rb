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

      #空きシフトを追加処理
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
          @already_request_event = current_staff.master.individual_shifts.find_by(start: @event.start, next_staff_id: current_staff.id)
          #シフトが重複しない用にする
          if @already_event.nil?
            if @already_request_event.present? || @event == @already_request_event
              return_html("alert")
            else
              if @event.mode == nil
                return_html("form_fill")
              else
                return_html("alert")
              end
            end
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
        if logged_in? && logged_in_staff?

          fill_in_master
    
        elsif !logged_in? && logged_in_staff?

          @event = current_staff.master.individual_shifts.find(params[:id])
          @event.mode = "fill"
          @event.next_staff_id = current_staff.id

        elsif logged_in? && !logged_in_staff?  

          fill_in_master
        end
        @event.save
      end
    
      #シフトの変更のmodalを表示
      def change
        begin
          if logged_in? && logged_in_staff?
            @event = current_master.individual_shifts.find(params[:shift_id])
            #終日の予定をクリックした時
    
            unless @event.allDay
              #店長権限でシフトをダイレクトに削除する
              if @event.mode == nil
                return_html("form_edit")
              elsif @event.mode == "instead"
                return_html("attend")
              end
            else
              return_html("plan_delete")
            end
    
          elsif !logged_in? && logged_in_staff?
            @event = current_staff.master.individual_shifts.find(params[:shift_id])
            @already_event = current_staff.individual_shifts.find_by(start: @event.start)
            @already_request_event = current_staff.master.individual_shifts.find_by(start: @event.start, next_staff_id: current_staff.id)
            #終日判定
            unless @event.allDay
              #イベントのモード
              if @event.mode.nil?
                #他人のシフトをクリック
                if @event.staff != current_staff
                  #シフト重複を避ける
                  if @already_event.present? || @already_request_event.present?
                    return_html("alert")
                  else
                    return_html('form_instead')
                  end
                # 自分の予定の場合
                else
                  return_html("shift_info")
                end
              else
                return_html("alert")
              end
            else
              return_html("alert")
            end
    
          elsif logged_in? && !logged_in_staff?
            @event = current_master.individual_shifts.find(params[:shift_id])
            unless @event.allDay
              #店長権限でシフトをダイレクトに削除する
              if @event.mode == nil
                return_html("form_edit")
              elsif @event.mode == "instead"
                return_html("judge_instead")
              end
            else
              return_html("plan_delete")
            end
          end
        rescue => exception
          #何もしない(祝日イベント対策)
        end
        
      end

      def admit
        @event = current_master.individual_shifts.find(params[:id])
        @event.staff = current_master.staffs.find(@event.next_staff_id)
        @event.next_staff_id = nil
        @event.mode = nil
        @event.save
      end

      def reject
        @event = current_master.individual_shifts.find(params[:id])
        @event.next_staff_id = nil
        @event.mode = nil
        @event.save
      end
    
      #交代申請処理
      def instead
        @shift  = current_staff.master.individual_shifts.find(params[:id])
        @shift.next_staff_id = current_staff.id
        @shift.mode = "instead"
        @shift.save
      end

      #空きシフトに変更
      def change_empty
        @shift = current_master.individual_shifts.find(params[:id])
        @shift.staff = current_master.staffs.find_by(staff_number:0)
        @shift.mode = nil
        @shift.next_staff_id = nil
        @shift.save
      end

      #店長がシフトインする
      def change_master
        @shift = current_master.individual_shifts.find(params[:id])
        @shift.staff = current_master.staffs.find_by(staff_number:current_master.staff_number)
        @shift.mode = nil
        @shift.next_staff_id = nil
        @shift.save
      end

      def change_shift
        if logged_in? && logged_in_staff?
          @event = current_master.individual_shifts.find(params[:shift_id])
          return_html("judge_instead")
        elsif !logged_in? && logged_in_staff?
          return_html("alert")
        elsif logged_in? && !logged_in_staff?
          @event = current_master.individual_shifts.find(params[:shift_id])
          return_html("judge_instead")
        end
      end

      def direct_change
        @event = current_master.individual_shifts.find(params[:id])
        name = params.require(:individual_shift).permit(:staff_name)
        new_staff = current_master.staffs.find_by(staff_name: name.values)

        logger.debug(@already_event)

        if new_staff.present?
          @already_event = current_master.individual_shifts.find_by(start: @event.start, staff_id: new_staff.id)
          unless @already_event.present?
            @event.staff = new_staff
            @event.save
          else
            render partial: "individual_shifts/duplicate"
          end
        else
          render partial: "perfect_shifts/error"
        end
      end
    
    private
        #店長ログイン時の空きシフトに入るためのmodal
        def fill_form_master
          @event = current_master.individual_shifts.find(params[:shift_id])
          #重複を避ける
          if @event.mode == nil
            return_html("form_fill")
          elsif @event.mode == "fill"
            return_html("judge_fill")
          end
        end
    
        #空きシフトに店長が入る処理
        def fill_in_master
          @event = current_master.individual_shifts.find(params[:id])
          @event.staff = current_master.staffs.find_by(staff_number:current_master.staff_number)
          @event.mode = nil
          @event.next_staff_id = nil
        end

        def params_shift
          params.require(:individual_shift).permit(:start, :finish)
        end
    
        def params_plan
          params.require(:individual_shift).permit(:plan, :start)
        end
end
