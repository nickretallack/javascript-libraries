(function() {
  (function($) {
    var defaults;
    $.event.fix = (function(originalFix) {
      return function(event) {
        event = originalFix.apply(this, arguments);
        if (event.type.indexOf('copy') === 0 || event.type.indexOf('paste') === 0) {
          event.clipboardData = event.originalEvent.clipboardData;
        }
        return event;
      };
    })($.event.fix);
    defaults = {
      callback: $.noop,
      matchType: /image.*/
    };
    return $.fn.pasteImageReader = function(options) {
      if (typeof options === "function") {
        options = {
          callback: options
        };
      }
      options = $.extend({}, defaults, options);
      return this.each(function() {
        var $this, element;
        element = this;
        $this = $(this);
        return $this.bind('paste', function(event) {
          var clipboardData, found;
          found = false;
          clipboardData = event.clipboardData;
          return Array.prototype.forEach.call(clipboardData.types, function(type, i) {
            var file;
            if (found) {
              return;
            }
            if (!type.match(options.matchType)) {
              return;
            }
            file = clipboardData.items[i].getAsFile();
            options.callback(file);
            return found = true;
          });
        });
      });
    };
  })(jQuery);
}).call(this);
