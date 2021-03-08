import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid'
import googleCalendarApi from '@fullcalendar/google-calendar'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new Calendar(calendarEl, {
        plugins: [ dayGridPlugin, interactionPlugin, googleCalendarApi ],
        events: '/comfirmed_shifts.json',
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
        scrollTime: '07:00:00',
        buttonText: {
            today: '今月'
        }, 
        headerToolbar: {
            left: '',
            center: 'title',
            right: 'today prev,next' 
        },
        dayCellContent: function(e) {
            e.dayNumberText = e.dayNumberText.replace('日', '');
        },
        eventClick: function(info){
            if (info.event.backgroundColor == "white"){
                var id = info.event.id
                $.ajax({
                    type: "GET",
                    url:  "/perfect_shifts/change",
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

    $(".error").click(function(){
        calendar.refetchEvents();
    });
});
