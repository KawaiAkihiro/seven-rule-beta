module PerfectShiftsHelper
    #指定したmodal用のhtmlを返す
    def return_html(html)
        render plain: render_to_string(partial: html, layout: false, locals: { event: @event })
    end
end
