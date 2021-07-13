class IndividualShiftsController < ApplicationController
    before_action :logged_in_staff, except: [:destroy]
    before_action :shift_onoff, except: [:destroy]

    require 'date'

    def index
        #このページで全てのアクションを実行していく
        @events = current_staff.individual_shifts.where(temporary: false)
        @shift_separation = current_staff.master.shift_separations.all
        @submit_start = current_staff.master.submits_start
        @submit_finish = current_staff.master.submits_finish
    end

    def new
        @event = current_staff.individual_shifts.new
        @patterns = current_staff.patterns.all
        #新規作成のmodal用のhtmlを返す
        render plain: render_to_string(partial: 'form_new', layout: false, locals: { event: @event, patterns: @patterns })
    end

    def create
        @event = current_staff.individual_shifts.new(params_event)
        #日付を自動調整
        change_finishDate 
        #同じ時間のシフトを捜索
        @already_event = current_staff.individual_shifts.where(start:@event.start).where(finish:@event.finish)
        
        #シフトパターンを作成
        @pattern = current_staff.patterns.new(params_event) 
        @already_pattern = current_staff.patterns.where(start: @pattern.start).where(finish: @pattern.finish)
        
        #すでに同じシフトを登録していないか判定
        unless @already_event.present?
            
            if @event.save  
                #過去に同じ時間帯に登録したことがなければ新しい登録パターンを追加
                unless @already_pattern.present?
                    @pattern.save
                end
                #シフト放棄状態の人が追加した時は放棄を無くす
                if current_staff.abandon 
                    current_staff.abandon = false
                    current_staff.save
                end
            else
                render partial: "error"
            end
        else
            #被りエラーを表示する
            render partial: "duplicate"   
        end 
    end 


    def remove
        @event = current_staff.individual_shifts.find(params[:shift_id])
        return_html("form_delete")
    end


    def destroy
        #両方でログイン中
        if logged_in_staff? && logged_in?
            @event = current_master.individual_shifts.find(params[:id]).destroy
        #従業員のみログイン中
        elsif logged_in_staff?
            @event = current_staff.individual_shifts.find(params[:id]).destroy
        #店長のみログイン中
        elsif logged_in?
            @event = current_master.individual_shifts.find(params[:id]).destroy
        end
    end

    def finish
        flash[:success] = "登録を終了しました！"
        redirect_to root_path
    end

    def abandon
        @shifts = current_staff.individual_shifts.where(temporary: false)
        logger.debug(@shifts)
        if @shifts.count == 0
            current_staff.abandon = true
            current_staff.save
            flash[:success] = "登録を終了しました！"
            redirect_to root_path
        else
            flash.now[:danger] = "シフトが登録されています"
            render "index"
        end
    end

    def not_submit_period
        return_html("not_submit_period")
    end

    def bulk_new
        @event = current_staff.individual_shifts.new
        @patterns = current_staff.patterns.all
        #新規作成のmodal用のhtmlを返す
        render plain: render_to_string(partial: 'form_bulknew', layout: false, locals: { event: @event, patterns: @patterns })
    end

    def bulk_create
        start = current_staff.master.submits_start
        finish = current_staff.master.submits_finish
        wdays = params[:wday][:ingredients].map(&:to_i)
        wdays.shift
        days = []
        if wdays.empty?
            render partial: "bulk_error"
        else
            (start..finish).each do |date|
                wdays.each do |i|
                    if date.wday == i
                        days.push(date)
                    end
                end
            end

            days.each do |day|
                date = [day.year, day.month, day.day]
                @event = current_staff.individual_shifts.new(params_event)
                @event.start = @event.start.change(year: date[0], month: date[1], day: date[2])
                #日付を自動調整
                change_finishDate 
                #同じ時間のシフトを捜索
                @already_event = current_staff.individual_shifts.where(start:@event.start).where(finish:@event.finish)
                
                #シフトパターンを作成
                @pattern = current_staff.patterns.new(params_event) 
                @already_pattern = current_staff.patterns.where(start: @pattern.start).where(finish: @pattern.finish)
                
                #すでに同じシフトを登録していないか判定
                unless @already_event.present?
                    
                    if @event.save  
                        #過去に同じ時間帯に登録したことがなければ新しい登録パターンを追加
                        unless @already_pattern.present?
                            @pattern.save
                        end
                        #シフト放棄状態の人が追加した時は放棄を無くす
                        if current_staff.abandon 
                            current_staff.abandon = false
                            current_staff.save
                        end
                    else
                        render partial: "error"
                        break
                    end
                else
                    #被りエラー回避
                    next
                end 
            end
        end
    end

    def bulk_delete_form
        @event = current_staff.individual_shifts.where("temporary": false)
        if @event.empty?
            return_html("empty_shift")
        else
            return_html("form_bulk_delete")
        end
        
    end

    def bulk_delete
        shifts = params[:delete][:ingredients].map(&:to_i)
        shifts.shift
        if shifts.empty?
            render partial: "bulk_error"
        else
            shifts.each do |shift|
                @event = current_staff.individual_shifts.find(shift)
                @event.destroy
            end
        end
    end


    private
      def params_event
        params.require(:individual_shift).permit(:start, :finish)
      end
end
