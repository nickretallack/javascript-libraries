cancel_event = (event) ->
    # Cancel an event in every possible way
    event ?= window.event
    event.cancelBubble = true
    event.stopPropagation?()
    event.preventDefault?()
    return false

### The Drag-and-Drop API was standardized in Internet Explorer 6.
It requires that you cancel dragover and dragenter when you are done with them.###

drop_files_here = (element, upload_url, success, error, progress) ->
    element.addEventListener 'dragover', (event) ->
            console.log("over")
            cancel_event(event)
    , false

    element.addEventListener 'dragenter', (event) ->
            console.log("enter")
            cancel_event(event);
    , false

    element.addEventListener 'dragleave', (event) ->
            console.log("leave")
            cancel_event(event); # don't need to cancel
    , false

    element.addEventListener 'drop', (event) ->
            return if not event.dataTransfer or not event.dataTransfer.files

            files = event.dataTransfer.files
            for file in files
                upload_file(file, upload_url, success, error, progress)

            console.log("drop")
            cancel_event(event); # don't cancel
    , false

monitor_progress = (request, handler) ->
    call_handler = (event) ->
        ### event.loaded = bytes received so far
        event.total  = total bytes according to the Content-Length header
        event.lengthComuptable = true if the Content-Length header is set ###
        if event.lengthComputable
            percent = (event.loaded / event.total) * 100
            return handler(percent)

    request.upload.addEventListener("progress", call_handler, false);
    request.upload.addEventListener("load", call_handler, false);

upload_file = (file, url, success_handler, error_handler, update_progress_bar) ->
    ### Webkit supports uploading multiple files in one web request, just like in a form,
    but lets focus on uploading one at a time for simplicity ###

    request = new XMLHttpRequest();
    monitor_progress(request, update_progress_bar)
    request.upload.addEventListener("error", error_handler, false);

    request.onreadystatechange = ->
        if request.readyState is 4  # DONE
            if request.status is 200 # SUCCESS
                success_handler(request.responseText)
            else # FAILURE
                error_handler(request)

    request.open("POST", url, true); # Last parameter may not be necessary

    if FormData? # Webkit
        upload_with_formdata(request, file)
    else if FileReader? # Firefox 3
        upload_with_filereader(request, file)
    else
        alert("Couldn't find a way to upload your files")


upload_with_formdata = (request, file) ->
    form_data = new FormData();
    form_data.append('Filedata', file);
    request.send(form_data);

# TODO: handle this server-side
upload_with_filereader = (request, file) ->
    reader = new FileReader();
    reader.onerror = (event) -> window.console.log("File read error")
    reader.onload = (event) ->
        window.console.log("File data loaded, uploading...")
        request.sendAsBinary(e.target.result)
    reader.readAsBinaryString(file);
