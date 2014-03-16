
require("coffee-script/register");
exports.projectManager = require("./src/projects/manager").manager;
exports.versionManager = require("./src/versions/manager").manager;
exports.collection = require("./src/utils/collection").collection;

exports.initialize = function() {
    scotty = new (require("./src/boot").boot)
    scotty.initialize()
    return scotty
};
