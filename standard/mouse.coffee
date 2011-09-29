window.Mouse = 
  buttons: {}
  location: $V 0,0
buttons = [null, "left", "middle", "right"]
  
set_button = (index, state) ->
  if index < buttons.length
    button_name = buttons[index]
    Mouse.buttons[button_name] = state
  
$(document).mousemove (event) ->
  Mouse.location = $V event.pageX, event.pageY

$(document).mousedown (event) ->
  set_button event.which,true

$(document).mouseup (event) ->
  set_button event.which,false
