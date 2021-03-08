import { Calendar} from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import weekGridPlugin from '@fullcalendar/timegrid'
import googleCalendarApi from '@fullcalendar/google-calendar'
//import dayGridPlugin from '@fullcalendar/daygrid'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ weekGridPlugin, interactionPlugin, googleCalendarApi ],
        events: '/deletable_shifts.json',
        googleCalendarApiKey: 'AIzaSyBJgxvPtAdElMF6qlcqWqIwFludRmesnOI',
        eventSources : [
            {
              googleCalendarId: 'japanese__ja@holiday.calendar.google.com',
              display: 'background',
              color:"#FF8C00"
            }
        ],
        locale: 'ja',
        timeZone: 'Asia/Tokyo',
        scrollTime: '07:00:00',
        slotDuration: "01:00:00" ,
        firstDay: 1,
        headerToolbar: {
            start: '',
            center: 'title',
            end: 'today prev,next' 
        },
        buttonText: {
            today: '今日'
        }, 
        allDayText: '営業 催事',
        height: "auto",

        eventClick: function(info){
            if (info.event.backgroundColor == "white"){
                var id = info.event.id
                $.ajax({
                    type: "GET",
                    url:  "/deletable_shifts/restore",
                    data: { shift_id : id },
                    datatype: "html",
                }).done(function(res){
                
                $('.modal-body').html(res)
                $('#modal').fadeIn();
                }).fail(function (result) {
                    // 失敗処理
                    alert("failed");
                });
            }
        },

        eventClassNames: function(arg){
            if(arg.event.allDay){
                return [ 'horizon' ]
            }else{
                return [ 'vertical' ]
            }
        }
    });

    calendar.render();

    $(".error").click(function(){
        calendar.refetchEvents();
    });
});