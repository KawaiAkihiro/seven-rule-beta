
import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid'
import googleCalendarApi from '@fullcalendar/google-calendar'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ dayGridPlugin, interactionPlugin, googleCalendarApi ],
        events: '/individual_shifts.json',
        googleCalendarApiKey: 'AIzaSyBJgxvPtAdElMF6qlcqWqIwFludRmesnOI',
        eventSources : [
            {
              googleCalendarId: 'japanese__ja@holiday.calendar.google.com',
              display: 'background',
              color:"#ffd0d0"
            }
        ],
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        firstDay: 1,
        theme: false,
        height: "auto",
        dayCellContent: function(e) {
            e.dayNumberText = e.dayNumberText.replace('日', '');

        },
        buttonText: {
            today: '今月'
        }, 
        headerToolbar: {
            start: '',
            center: 'title',
            end: 'today prev,next' 
        },
        dateClick: function(info){
            const year  = info.date.getFullYear();
            const month = (info.date.getMonth() + 1);
            const day   = info.date.getDate();

            let date = new Date(year, month-1, day)

            let submit_start = $("#submit_start").data("submit_start")
            let start_info = submit_start.split("-")
            let start_year = Number(start_info[0].substr(1,4))
            let start_month = Number(start_info[1])
            let start_day   = Number(start_info[2].substr(0,2))

            let start_date = new Date(start_year, start_month-1, start_day)

            let submit_finish = $("#submit_finish").data("submit_finish")
            let finish_info = submit_finish.split("-")
            let finish_year = Number(finish_info[0].substr(1,4))
            let finish_month = Number(finish_info[1])
            let finish_day   = Number(finish_info[2].substr(0,2))

            let finish_date = new Date(finish_year, finish_month-1, finish_day)

            if (start_date <= date && date <= finish_date){
                $.ajax({
                    type: 'GET',
                    url:  '/individual_shifts/new',
                }).done(function (res) {
                    //イベント登録用のhtmlを作成
                    $('.modal-body').html(res);
                    
                    $('#individual_shift_start_1i').val(year);
                    $('#individual_shift_start_2i').val(month);
                    $('#individual_shift_start_3i').val(day);
                
                    $('#modal').fadeIn();
                    // 成功処理
                }).fail(function (result) {
                    // 失敗処理
                    // alert("failed");
                });
            }else{
                $.ajax({
                    type: 'GET',
                    url:  '/individual_shifts/not_submit_period',
                }).done(function (res) {
                    //イベント登録用のhtmlを作成
                    $('.modal-body').html(res);
                    $('#modal').fadeIn();
                    // 成功処理
                }).fail(function (result) {
                    // 失敗処理
                    // alert("failed");
                });
            }
        },
        eventClick: function(info){
            if (info.event.backgroundColor == "white"){
                var id = info.event.id
                $.ajax({
                    type: "GET",
                    url:  "/individual_shifts/remove",
                    data: { shift_id : id },
                    datatype: "html",
                }).done(function(res){
                
                    $('.modal-body').html(res)
                    $('#modal').fadeIn();
                }).fail(function (result) {
                    // 失敗処理
                    // alert("failed");
                });
            }
        },
        eventClassNames: function(arg){
            return [ 'horizon' ]
        }
    });

    calendar.render();

    $('button').click(function(){
        calendar.refetchEvents();
    });
});