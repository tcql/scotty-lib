(function() {
  var async,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  async = require('async');

  exports.storage = (function() {
    function storage(db, checker) {
      this.db = db;
      this.checker = checker;
      this._formatRecord = __bind(this._formatRecord, this);
      this._insertNew = __bind(this._insertNew, this);
    }

    storage.prototype.syncVersionList = function(versions, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return async.map(versions, this._insertNew.bind(this), (function(_this) {
        return function(err, results) {
          return callback(versions, err, results);
        };
      })(this));
    };

    storage.prototype.install = function(version, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.update({
        name: version
      }, {
        $set: {
          installed: true,
          in_progress: false
        }
      }, callback);
    };

    storage.prototype.get = function(version, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.findOne({
        name: version
      }, callback);
    };

    storage.prototype.getInstalled = function(callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.find({
        "installed": true
      }).sort({
        name: -1
      }).exec(callback);
    };

    storage.prototype.getAll = function(callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.find({}).sort({
        name: -1
      }).exec(callback);
    };

    storage.prototype.getLatest = function(callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.find({}, (function(_this) {
        return function(err, docs) {
          var max, ver, vers, _i, _len;
          vers = [];
          for (_i = 0, _len = docs.length; _i < _len; _i++) {
            ver = docs[_i];
            vers.push(ver.clean);
          }
          max = _this.checker.getLatest(vers);
          return _this.db.findOne({
            clean: max
          }, callback);
        };
      })(this));
    };

    storage.prototype.isInstalled = function(name, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.count({
        name: name,
        installed: true
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

    storage.prototype.setInProgress = function(version, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.update({
        name: version
      }, {
        $set: {
          in_progress: true
        }
      }, callback);
    };

    storage.prototype.setNoneInProgress = function(callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.db.update({}, {
        $set: {
          in_progress: false
        }
      }, {
        multi: true
      }, callback);
    };

    storage.prototype._insertNew = function(version, callback) {
      var self;
      self = this;
      return this.db.findOne({
        name: version.name
      }, function(err, doc) {
        var record;
        if (doc == null) {
          record = self._formatRecord(version);
          return self.db.insert(record, function(err) {
            return callback(err, record);
          });
        } else {
          return callback(null, null);
        }
      });
    };

    storage.prototype._formatRecord = function(version) {
      return {
        name: version.name,
        installed: false,
        url: version.tarball_url,
        clean: this.checker.cleanVersion(version.name),
        in_progress: false
      };
    };

    return storage;

  })();

}).call(this);
