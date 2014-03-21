
exports.projectManager = require("./build/projects/manager").manager;
exports.versionManager = require("./build/versions/manager").manager;

exports.initialize = function() {
    scotty = new (require("./build/boot").boot)
    scotty.initialize()
    return scotty
};
