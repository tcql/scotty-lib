(function() {
  var nedb, project, storage,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  project = require('./project').project;

  storage = require('./storage').storage;

  nedb = require('nedb');

  exports.manager = (function() {
    function manager(options) {
      this.options = options;
      this.getDefaultTemplate = __bind(this.getDefaultTemplate, this);
      this.boot = __bind(this.boot, this);
    }

    manager.prototype.boot = function() {
      this._projectdb = new nedb({
        filename: this.options.project_file,
        autoload: this.options.autoload
      });
      this._project_files = new project(this.options);
      return this.projects = new storage(this._projectdb);
    };

    manager.prototype.create = function(project, options, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.projects.nameInUse(project.name, (function(_this) {
        return function(exists) {
          if (exists) {
            callback(["A project with that name already exists"], null);
          }
          _this._project_files.createOnDiskByCopy(project, _this.getDefaultTemplate());
          _this._project_files.installPhaser(project);
          return _this.projects.add(project, callback);
        };
      })(this));
    };

    manager.prototype.update = function(id, project, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.projects.getById(id, (function(_this) {
        return function(err, old) {
          if (err) {
            return callback(err, null);
          }
          if (old.path !== project.path) {
            _this._project_files.moveOnDisk(old, project);
          }
          if (old.phaser_version !== project.phaser_version) {
            _this._project_files.uninstallPhaser(old);
            _this._project_files.installPhaser(project);
          }
          return _this.projects.update(project, callback);
        };
      })(this));
    };

    manager.prototype["delete"] = function(id, callback) {
      if (callback == null) {
        callback = function() {};
      }
      return this.projects.getById(id, (function(_this) {
        return function(err, project) {
          if (err) {
            callback(err, null);
          }
          return _this.projects.deleteById(id, function(err, numDel) {
            if (err) {
              callback(err, null);
            }
            if (numDel > 0) {
              _this._project_files.deleteOnDisk(project);
            }
            return callback(null, project);
          });
        };
      })(this));
    };

    manager.prototype.getDefaultTemplate = function() {
      return this.options.template_path + "/hello_phaser";
    };

    return manager;

  })();

}).call(this);
