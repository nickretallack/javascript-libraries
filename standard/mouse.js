(function() {
  var buttons, set_button;
  window.Mouse = {
    buttons: {},
    location: $V(0, 0)
  };
  buttons = [null, "left", "middle", "right"];
  set_button = function(index, state) {
    var button_name;
    if (index < buttons.length) {
      button_name = buttons[index];
      return Mouse.buttons[button_name] = state;
    }
  };
  $(document).mousemove(function(event) {
    return Mouse.location = $V(event.pageX, event.pageY);
  });
  $(document).mousedown(function(event) {
    return set_button(event.which, true);
  });
  $(document).mouseup(function(event) {
    return set_button(event.which, false);
  });
}).call(this);
