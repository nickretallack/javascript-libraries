db = null
set_db = (the_db) -> db = the_db

handle_errors = (success, failure) ->
    (error, result) ->
        if error
            db.query 'rollback'
            console.log "DATABASE ERROR: #{JSON.stringify(error)}"
            failure error if failure
        else
            success result
        
query = (one, two, three, four) ->
    if typeof two is 'function'
        two = handle_errors two, three
    else
        three = handle_errors three, four
    db.query one, two, three

exports.query = query
exports.set_db = set_db
