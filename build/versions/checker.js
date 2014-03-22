(function() {
  var semver;

  semver = require('semver');

  exports.checker = (function() {
    function checker() {}

    checker.prototype.cleanVersion = function(orig_version) {
      var nums, version;
      version = orig_version.replace(/[^0-9\.]/g, '');
      nums = version.split('.');
      nums = nums.filter(function(elem) {
        return elem !== "";
      });
      if (nums.length === 3) {
        return nums.join('.');
      } else if (nums.length === 2) {
        return "" + nums[0] + "." + nums[1] + ".0";
      } else if (nums.length === 1) {
        return "" + nums[0] + ".0.0";
      } else {
        throw Error("invalid version " + orig_version);
      }
    };

    checker.prototype.getLatest = function(versions) {
      versions = versions.map((function(_this) {
        return function(elem) {
          return _this.cleanVersion(elem);
        };
      })(this));
      return semver.maxSatisfying(versions, ">0.0.0");
    };

    checker.prototype.isLatest = function(version, versions) {
      return this.getLatest(versions) === this.cleanVersion(version);
    };

    return checker;

  })();

}).call(this);
