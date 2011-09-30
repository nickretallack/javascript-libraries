(function() {
  var db, handle_errors, query, set_db;
  db = null;
  set_db = function(the_db) {
    return db = the_db;
  };
  handle_errors = function(success, failure) {
    return function(error, result) {
      if (error) {
        db.query('rollback');
        console.log("DATABASE ERROR: " + (JSON.stringify(error)));
        if (failure) {
          return failure(error);
        }
      } else {
        return success(result);
      }
    };
  };
  query = function(one, two, three, four) {
    if (typeof two === 'function') {
      two = handle_errors(two, three);
    } else {
      three = handle_errors(three, four);
    }
    return db.query(one, two, three);
  };
  exports.query = query;
  exports.set_db = set_db;
}).call(this);
