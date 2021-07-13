import { Calendar, whenTransitionDone } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import weekGridPlugin from '@fullcalendar/timegrid'
//import dayGridPlugin from '@fullcalendar/daygrid'
import googleCalendarApi from '@fullcalendar/google-calendar'

document.addEventListener('turbolinks:load', function() {
    var calendarEl = document.getElementById('calendar');
    var width = window.innerWidth;

    var calendar = new Calendar(calendarEl, {
        plugins: [ weekGridPlugin, interactionPlugin, googleCalendarApi ],
        events: '/temporary_shifts.json',
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
        slotMinTime: '07:00:00',
        slotMaxTime: '31:00;00',
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