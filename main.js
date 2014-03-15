
require("coffee-script/register");
exports.projectManager = require("./src/projects/manager").manager;
exports.versionManager = require("./src/versions/manager").manager;

exports.boot = new (require("./src/boot").boot)
