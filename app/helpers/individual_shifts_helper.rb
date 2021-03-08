module IndividualShiftsHelper
    #退勤時間の日付を出勤時間の日付に合わせる
    def change_finishDate 
        #日付を跨がない場合はそのまま,日付を跨ぐ場合は1日プラスする。
        if @event.start.hour > @event.finish.hour  
            last_day = Date.new(@event.start.year,@event.start.month,-1).day #月末の日にちを取得
            if @event.start.month == 12 && @event.start.day == 31            #大晦日
                @event.finish = @event.finish.change(year: @event.start.year + 1 ,  month: 1, day: 1)
            elsif !(@event.start.month == 12) && @event.start.day == last_day #普通の月末
                @event.finish = @event.finish.change(year: @event.start.year,  month: @event.start.month + 1, day: 1)
            else #月末でもない日
                @event.finish = @event.finish.change(year: @event.start.year,  month: @event.start.month,     day: @event.start.day + 1)
            end
        else #ただの夜越ししない時間帯
            @event.finish = @event.finish.change(year: @event.start.year, month: @event.start.month, day: @event.start.day)
        end
    end
end
