json.array!(@events) do |event|
    json.id event.id
    json.title event.time
    json.start event.start  
    json.end event.finish 
    json.allDay event.allDay
    json.textColor "black"
    json.backgroundColor "white"
    json.borderColor "black"
  end