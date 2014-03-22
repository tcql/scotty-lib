(function() {
  var fs, request, tar, zlib;

  request = require('request');

  zlib = require('zlib');

  tar = require('tar');

  fs = require('fs-extra');

  exports.examples = (function() {
    function examples(options) {
      this.options = options;
    }

    examples.prototype.installed = function() {
      return fs.existsSync(this.options.examples_path);
    };

    examples.prototype.download = function(on_complete) {
      var dest, options, req, url;
      if (on_complete == null) {
        on_complete = function() {};
      }
      dest = this.options.examples_path;
      fs.removeSync(dest);
      url = this.getDownloadUrl();
      options = {
        headers: {
          "User-Agent": 'test/1.0'
        }
      };
      req = request(url, options);
      req.pipe(zlib.createGunzip()).pipe(tar.Extract({
        path: "" + dest,
        strip: 1
      }));
      return req.on('end', (function(_this) {
        return function() {
          return on_complete();
        };
      })(this));
    };

    examples.prototype.getDownloadUrl = function() {
      return "https://github.com/photonstorm/phaser-examples/archive/master.tar.gz";
    };

    return examples;

  })();

}).call(this);
