(function() {
  var fs, path;

  fs = require('fs-extra');

  path = require('path');

  exports.project = (function() {
    function project(paths) {
      this.paths = paths;
    }

    project.prototype.createOnDiskByCopy = function(project, template) {
      var location;
      location = project.path;
      location = path.resolve(location);
      fs.removeSync(location);
      if (fs.existsSync(template)) {
        fs.copySync(template, location);
        project.path = location;
        return true;
      }
      return false;
    };

    project.prototype.createOnDisk = function(project) {
      var location;
      location = project.path;
      location = path.resolve(location);
      if (!fs.existsSync(location)) {
        fs.mkdirSync(location);
        location.path = location;
        return true;
      }
      return false;
    };

    project.prototype.moveOnDisk = function(original, project) {
      var location, res;
      location = path.resolve(project.path);
      fs.removeSync(location);
      if (fs.existsSync(original.path)) {
        res = fs.renameSync(original.path, location);
        return true;
      }
      return false;
    };

    project.prototype.installPhaser = function(project, version) {
      var phaser, phaser_dest, _ref;
      if (version == null) {
        version = null;
      }
      version = version != null ? version : project.phaser_version;
      phaser = "" + this.paths.phaser_path + "/" + version;
      phaser_dest = (_ref = project.phaser_path) != null ? _ref : project.path + "/phaser";
      if (fs.existsSync(phaser)) {
        fs.copySync(phaser, phaser_dest);
        project.phaser_path = phaser_dest;
        return true;
      }
      return false;
    };

    project.prototype.uninstallPhaser = function(project) {
      return fs.removeSync(project.phaser_path);
    };

    project.prototype.deleteOnDisk = function(project) {
      if (fs.existsSync(project.path)) {
        fs.removeSync(project.path);
        return true;
      }
      return false;
    };

    return project;

  })();

}).call(this);
