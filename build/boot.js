(function() {
  var examples, fs, github, projects, versions;

  fs = require('fs-extra');

  github = require('github');

  versions = require("./versions/manager").manager;

  projects = require("./projects/manager").manager;

  examples = require("./examples").examples;

  exports.boot = (function() {
    function boot() {}

    boot.prototype.initialize = function() {
      var _ref;
      this.makeBaseDirectory();
      this.options = {
        examples_path: this.getExamplesDirectory(),
        template_path: this.getTemplateDirectory(),
        phaser_path: this.getPhaserDirectory(),
        version_file: this.getVersionFile(),
        project_file: this.getProjectFile(),
        autoload: true
      };
      this.installTemplates();
      this.api = new github({
        version: "3.0.0",
        debug: (_ref = this.options.debug) != null ? _ref : false,
        protocol: "https"
      });
      this.versions = new versions(this.options);
      this.versions.setApi(this.api);
      this.projects = new projects(this.options);
      this.examples = new examples(this.options);
      this.versions.boot();
      return this.projects.boot();
    };

    boot.prototype.getHomeDirectory = function() {
      var path;
      path = process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;
      return fs.realpathSync(path);
    };

    boot.prototype.getBaseDirectory = function() {
      return this.getHomeDirectory() + "/.scotty";
    };

    boot.prototype.getPhaserDirectory = function() {
      return this.getBaseDirectory() + "/engine";
    };

    boot.prototype.getVersionFile = function() {
      return this.getBaseDirectory() + "/versions.db";
    };

    boot.prototype.getProjectFile = function() {
      return this.getBaseDirectory() + "/projects.db";
    };

    boot.prototype.makeBaseDirectory = function() {
      var dir;
      dir = this.getBaseDirectory();
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
        return fs.mkdirSync(this.getPhaserDirectory());
      }
    };

    boot.prototype.getExamplesDirectory = function() {
      return this.getBaseDirectory() + "/phaser-examples";
    };

    boot.prototype.getTemplateDirectory = function() {
      return this.getBaseDirectory() + "/templates";
    };

    boot.prototype.installTemplates = function() {
      if (!fs.existsSync(this.getTemplateDirectory())) {
        return fs.copySync(__dirname + "/../templates", this.getTemplateDirectory());
      }
    };

    return boot;

  })();

}).call(this);
