
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

            @projects_db = new nedb
                filename: @getProjectFile()
                autoload: true

            @options =
                phaser_path:    @getPhaserDirectory()
                version_file:   @getVersionFile()
                project_file:   @getProjectFile()
                autoload:       true

            # @versions = new versions @database, @options
            # @projects = new projects @database, @options

            # @versions.boot()
            # @projects.boot()


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

* The **versions.db** file

        getVersionFile: ()->
            return @getBaseDirectory()+"/versions.db"

* The **projects.db** file

        getProjectFile: ()->
            return @getBaseDirectory()+"/projects.db"


During initialization, the base directory is created if it does not exist

        makeBaseDirectory: ()->
            dir = @getBaseDirectory()

            if not fs.existsSync(dir)
                fs.mkdirSync(dir)
                fs.mkdirSync(@getPhaserDirectory())



