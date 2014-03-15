fs = require('fs-extra')
versions = require("./versions/manager").manager
projects = require("./projects/manager").manager

class exports.boot

    initialize: ()->
        @makeBaseDirectory()
        @versions = new versions
            version_file: @getVersionFile()
            phaser_path: @getPhaserDirectory()
            project_file: @getProjectFile()


    makeBaseDirectory: ()->
        dir = @getBaseDirectory()

        if not fs.existsSync(dir)
            fs.mkdirSync(dir)
            fs.mkdirSync(@getPhaserDirectory())


    getVersionFile: ()->
        return @getBaseDirectory()+"/versions.json"

    getProjectFile: ()->
        return @getBaseDirectory()+"/projects.json"

    getPhaserDirectory: ()->
        return @getBaseDirectory()+"/engine"

    getBaseDirectory: ()->
        return @getHomeDirectory()+"/.scotty"

    getHomeDirectory: ()->
        return process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE
