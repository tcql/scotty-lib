(function() {
  var fs, progress, request, tar, zlib;

  request = require('request');

  zlib = require('zlib');

  tar = require('tar');

  fs = require('fs-extra');

  progress = require('request-progress');

  exports.examples = (function() {
    function examples(options) {
      this.options = options;
    }

    examples.prototype.installed = function() {
      return fs.existsSync(this.options.examples_path);
    };

    examples.prototype.download = function(on_complete, on_progress) {
      var dest, options, req, url;
      on_complete = on_complete != null ? on_complete : function() {};
      on_progress = on_progress != null ? on_progress : function() {};
      dest = this.options.examples_path;
      fs.removeSync(dest);
      url = this.getDownloadUrl();
      options = {
        headers: {
          "User-Agent": 'test/1.0'
        }
      };
      return req = progress(request(url, options)).on('progress', on_progress).on('end', on_complete).pipe(zlib.createGunzip()).pipe(tar.Extract({
        path: "" + dest,
        strip: 1
      }));
    };

    examples.prototype.getDownloadUrl = function() {
      return "https://github.com/photonstorm/phaser-examples/archive/master.tar.gz";
    };

    return examples;

  })();

}).call(this);
