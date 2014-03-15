
    fs = require('fs-extra')
    versions = require("./versions/manager").manager
    projects = require("./projects/manager").manager

Scotty Boot
===========
The scotty boot class handles initialization and file locating for the standard
configuration.

    class exports.boot


Initalization
-------------
The initialization method creates the default scotty folder structure in the current user's
home directory and initializes scotty components with default options

        initialize: ()->
            @makeBaseDirectory()

            @options =
                version_file: @getVersionFile()
                phaser_path: @getPhaserDirectory()
                project_file: @getProjectFile()

            @versions = new versions @options
            @projects = new projects @options


Locations
---------
Scotty requires a location to store phaser engine versions as well as metadata json files about
installed engine versions and project locations. The location is a subfolder of the current user's
home directory.

        getHomeDirectory: ()->
            return process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE


        getBaseDirectory: ()->
            return @getHomeDirectory()+"/.scotty"


Within the **.scotty** folder, three primary elements are stored:

* The folder where phaser engine versions will be downloaded and installed

        getPhaserDirectory: ()->
            return @getBaseDirectory()+"/engine"

* The **versions.json** file

        getVersionFile: ()->
            return @getBaseDirectory()+"/versions.json"

* The **projects.json** file

        getProjectFile: ()->
            return @getBaseDirectory()+"/projects.json"


During initialization, the base directory is created if it does not exist

        makeBaseDirectory: ()->
            dir = @getBaseDirectory()

            if not fs.existsSync(dir)
                fs.mkdirSync(dir)
                fs.mkdirSync(@getPhaserDirectory())


