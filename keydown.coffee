define [
    './keycodes'
    './jquery'
], (special_keys, $) ->
    pressed_keys = {}
    key_name = (event) ->
        special_keys[event.which] || 
        String.fromCharCode(event.which).toLowerCase()
  
    $(document).bind "keydown", (event) ->
        pressed_keys[key_name(event)] = true
  
    $(document).bind "keyup", (event) ->
        pressed_keys[key_name(event)] = false

    pressed_keys
