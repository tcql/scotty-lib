(function() {
  var checker, fetcher, github, nedb, storage;

  fetcher = require('./fetcher').fetcher;

  checker = require('./checker').checker;

  storage = require("./storage").storage;

  nedb = require('nedb');

  github = require('github');

  exports.manager = (function() {
    function manager(options) {
      this.options = options != null ? options : {};
    }

    manager.prototype.boot = function() {
      var _ref;
      if (!this.api) {
        this.api = new github({
          version: "3.0.0",
          debug: (_ref = this.options.debug) != null ? _ref : false,
          protocol: "https"
        });
      }
      this.checker = new checker;
      this.fetcher = new fetcher(this.api, this.checker);
      this._versiondb = new nedb({
        filename: this.options.version_file,
        autoload: this.options.autoload
      });
      this.versions = new storage(this._versiondb, this.checker);
      return this.versions.setNoneInProgress();
    };

    manager.prototype.fetch = function(callback) {
      return this.fetcher.fetchVersions((function(_this) {
        return function(versions) {
          return _this.versions.syncVersionList(versions, callback);
        };
      })(this));
    };

    manager.prototype.forceDownload = function(version, cb, onProgress) {
      if (onProgress == null) {
        onProgress = function() {};
      }
      return this._download(version, cb, onProgress);
    };

    manager.prototype.download = function(version, callback, onProgress) {
      if (onProgress == null) {
        onProgress = function() {};
      }
      return this.versions.isInstalled(version, (function(_this) {
        return function(exists) {
          if (!exists) {
            return _this._download(version, callback, onProgress);
          } else {
            return callback(false);
          }
        };
      })(this));
    };

    manager.prototype._download = function(version, callback, onProgress) {
      if (onProgress == null) {
        onProgress = function() {};
      }
      return this.versions.get(version, (function(_this) {
        return function(err, ver) {
          var request;
          if (!ver) {
            return callback(false);
          }
          _this.versions.setInProgress(version);
          return request = _this.fetcher.download(version, ver.url, _this.options.phaser_path, onProgress, function() {
            return _this.versions.install(version, callback);
          });
        };
      })(this));
    };

    manager.prototype.setChecker = function(checker) {
      return this.checker = check;
    };

    manager.prototype.setFile = function(local) {
      return this.file = local;
    };

    manager.prototype.setFetcher = function(fetcher) {
      return this.fetcher = fetcher;
    };

    manager.prototype.setDb = function(db) {
      this._versiondb = db;
      return this.versions.db = db;
    };

    manager.prototype.setApi = function(api) {
      return this.api = api;
    };

    return manager;

  })();

}).call(this);
