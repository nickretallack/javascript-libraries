# Created by STRd6
# MIT License
# jquery.paste_image_reader.js.coffee
(($) ->
  # Make sure paste events get clipboard data
  $.event.fix = ((originalFix) ->
    (event) ->
      event = originalFix.apply(this, arguments)
 
      if event.type.indexOf('copy') == 0 || event.type.indexOf('paste') == 0
        event.clipboardData = event.originalEvent.clipboardData
 
      return event
  )($.event.fix)
 
  defaults =
    callback: $.noop
    matchType: /image.*/
 
  # Create the plugin
  # To use it: $("html").pasteImageReader callback
  $.fn.pasteImageReader = (options) ->
    if typeof options == "function"
      options =
        callback: options
 
    options = $.extend({}, defaults, options)
 
    # Listen to paste events on each element in the selector
    this.each () ->
      element = this
      $this = $(this)
 
      $this.bind 'paste', (event) ->
        found = false
        clipboardData = event.clipboardData
 
        # Loop through all types the data can be pasted as until 
        # we hit an image type
        Array::forEach.call clipboardData.types, (type, i) ->
          return if found
          return unless type.match(options.matchType)
 
          # Get the corresponding file data
          file = clipboardData.items[i].getAsFile()
 
          # Read the file data and fire off the callback with
          # the useful stuff when it's been read
          reader = new FileReader()
          reader.onload = (evt) ->
            options.callback.call element,
              filename: file.name
              dataURL: evt.target.result
 
          reader.readAsDataURL(file)
 
          # We found an image, we're done
          found = true
 
)(jQuery)
