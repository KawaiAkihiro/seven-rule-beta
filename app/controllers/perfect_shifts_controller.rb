class PerfectShiftsController < ApplicationController
      def index
        #このページで全てのアクションを起こす
        if logged_in? && logged_in_staff?
            @events = current_master.individual_shifts.where(temporary: true)
        elsif logged_in_staff?
            @events = current_staff.master.individual_shifts.where(temporary: true)
        elsif logged_in?
            @events = current_master.individual_shifts.where(temporary: true)
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
        @event.staff = current_master.staffs.find_by(number: 0)
        @event.temporary = true
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
        @event.staff = current_master.staffs.find_by(number: 0)
        @event.temporary = true
        unless @event.save
          render partial: "individual_shifts/error"
        end
      end
    
      #空きシフトを埋めるmodalを表示
      def fill
        #両方ログイン中
        if logged_in? && logged_in_staff?
          fill_form_master
    
        # #従業員のみログイン時
        elsif logged_in_staff?
          return_html("alert")
    
        #店長のみログイン時
        elsif logged_in?
          fill_form_master
        
        end
      end
    
      #空きシフトを埋める処理
      def fill_in
        if logged_in? && logged_in_staff?

          fill_in_master

      elsif logged_in?

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
    
          elsif logged_in_staff?
            @event = current_staff.master.individual_shifts.find(params[:shift_id])
            #終日判定
            unless @event.allDay
              return_html("shift_info")
            else
              return_html("alert")
            end
    
          elsif logged_in?
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
      #空きシフトに変更
      def change_empty
        @event = current_master.individual_shifts.find(params[:id])
        @event.staff = current_master.staffs.find_by(number:0)
        @event.mode = nil
        @event.next_staff_id = nil
        @event.save
      end

      #店長がシフトインする
      def change_master
        @event = current_master.individual_shifts.find(params[:id])
        @event.staff = current_master.staffs.find_by(number:current_master.staff_number)
        @event.mode = nil
        @event.next_staff_id = nil
        @event.save
      end

      #店長が店舗で書きかえられた変更を反映する
      def direct_change
        @event = current_master.individual_shifts.find(params[:id])
        name = params.require(:individual_shift).permit(:name)
        new_staff = current_master.staffs.find_by(name: name.values)

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
          @event.staff = current_master.staffs.find_by(number:current_master.staff_number)
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
