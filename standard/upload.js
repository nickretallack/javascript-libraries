(function() {
  var cancel_event, monitor_progress, upload_with_filereader, upload_with_formdata;
  cancel_event = function(event) {
        if (event != null) {
      event;
    } else {
      event = window.event;
    };
    event.cancelBubble = true;
    if (typeof event.stopPropagation === "function") {
      event.stopPropagation();
    }
    if (typeof event.preventDefault === "function") {
      event.preventDefault();
    }
    return false;
  };
  /* The Drag-and-Drop API was standardized in Internet Explorer 6.
  It requires that you cancel dragover and dragenter when you are done with them.*/
  window.drop_files_here = function(element, upload_url, success, error, progress) {
    element.addEventListener('dragover', function(event) {
      console.log("over");
      return cancel_event(event);
    }, false);
    element.addEventListener('dragenter', function(event) {
      console.log("enter");
      return cancel_event(event);
    }, false);
    element.addEventListener('dragleave', function(event) {
      console.log("leave");
      return cancel_event(event);
    }, false);
    return element.addEventListener('drop', function(event) {
      var file, files, _i, _len;
      if (!event.dataTransfer || !event.dataTransfer.files) {
        return;
      }
      files = event.dataTransfer.files;
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        upload_file(file, upload_url, success, error, progress);
      }
      console.log("drop");
      return cancel_event(event);
    }, false);
  };
  monitor_progress = function(request, handler) {
    var call_handler;
    call_handler = function(event) {
      /* event.loaded = bytes received so far
      event.total  = total bytes according to the Content-Length header
      event.lengthComuptable = true if the Content-Length header is set */      var percent;
      if (event.lengthComputable) {
        percent = (event.loaded / event.total) * 100;
        return handler(percent);
      }
    };
    request.upload.addEventListener("progress", call_handler, false);
    return request.upload.addEventListener("load", call_handler, false);
  };
  window.upload_file = function(file, url, success_handler, error_handler, update_progress_bar) {
    /* Webkit supports uploading multiple files in one web request, just like in a form,
    but lets focus on uploading one at a time for simplicity */    var request;
    request = new XMLHttpRequest();
    monitor_progress(request, update_progress_bar);
    request.upload.addEventListener("error", error_handler, false);
    request.onreadystatechange = function() {
      if (request.readyState === 4) {
        if (request.status === 200) {
          return success_handler(request.responseText);
        } else {
          return error_handler(request);
        }
      }
    };
    request.open("POST", url, true);
    if (typeof FormData !== "undefined" && FormData !== null) {
      return upload_with_formdata(request, file);
    } else if (typeof FileReader !== "undefined" && FileReader !== null) {
      return upload_with_filereader(request, file);
    } else {
      return alert("Couldn't find a way to upload your files");
    }
  };
  upload_with_formdata = function(request, file) {
    var form_data;
    form_data = new FormData();
    form_data.append('file', file);
    return request.send(form_data);
  };
  upload_with_filereader = function(request, file) {
    var reader;
    reader = new FileReader();
    reader.onerror = function(event) {
      return window.console.log("File read error");
    };
    reader.onload = function(event) {
      window.console.log("File data loaded, uploading...");
      return request.sendAsBinary(e.target.result);
    };
    return reader.readAsBinaryString(file);
  };
}).call(this);
