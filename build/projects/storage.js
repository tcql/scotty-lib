(function() {
  exports.storage = (function() {
    function storage(db) {
      this.db = db;
    }

    storage.prototype.getAll = function(callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.find({}, callback);
    };

    storage.prototype.getByName = function(name, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.findOne({
        name: name
      }, callback);
    };

    storage.prototype.getById = function(id, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.findOne({
        _id: id
      }, callback);
    };

    storage.prototype.getBy = function(query, callback) {
      if (query == null) {
        query = {};
      }
      if (callback == null) {
        callback = function() {};
      }
      return this.db.findOne(query, callback);
    };

    storage.prototype.nameInUse = function(name, callback) {
      return this.db.count({
        name: name
      }, (function(_this) {
        return function(err, count) {
          if (count > 0) {
            return callback(true);
          } else {
            return callback(false);
          }
        };
      })(this));
    };

    storage.prototype.add = function(project, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.insert(project, callback);
    };

    storage.prototype.update = function(project, callback) {
      var id;
      if (callback == null) {
        callback = function() {};
      }
      id = project._id;
      delete project["_id"];
      return this.db.update({
        _id: id
      }, {
        $set: project
      }, {}, callback);
    };

    storage.prototype.deleteById = function(id, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.remove({
        _id: id
      }, {}, callback);
    };

    return storage;

  })();

}).call(this);
