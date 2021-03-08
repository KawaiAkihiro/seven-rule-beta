json.array!(@events) do |event|
    json.id event.id
    json.title event.parent
    json.start event.start  
    json.end event.finish 
    json.allDay event.allDay
    json.textColor "black"
    json.backgroundColor event.backgroundColor
    json.borderColor event.color
  end