(function() {
  var request, tar, zlib;

  request = require('request');

  zlib = require('zlib');

  tar = require('tar');

  exports.fetcher = (function() {
    function fetcher(api) {
      this.api = api;
    }

    fetcher.prototype.fetchVersions = function(cb) {
      if (cb == null) {
        cb = function() {};
      }
      return this.api.repos.getTags({
        user: "photonstorm",
        repo: "phaser"
      }, (function(_this) {
        return function(err, versions) {
          var version, _i, _len;
          for (_i = 0, _len = versions.length; _i < _len; _i++) {
            version = versions[_i];
            version.url = version.tarball_url;
          }
          return cb(versions);
        };
      })(this));
    };

    fetcher.prototype.download = function(version, url, destination, on_complete) {
      var options, req;
      if (on_complete == null) {
        on_complete = function() {};
      }
      options = {
        headers: {
          "User-Agent": 'test/1.0'
        }
      };
      req = request(url, options);
      req.pipe(zlib.createGunzip()).pipe(tar.Extract({
        path: "" + destination + "/" + version,
        strip: 1
      }));
      req.on('end', (function(_this) {
        return function() {
          return on_complete("" + destination + "/" + version);
        };
      })(this));
      return req;
    };

    return fetcher;

  })();

}).call(this);
