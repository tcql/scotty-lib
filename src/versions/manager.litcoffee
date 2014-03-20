    {fetcher} = require('./fetcher')
    {checker} = require('./checker')
    {storage} = require("./storage")

    nedb = require('nedb')
    github = require('github')

Version Manager
===============
The version Manager class is the externally exposed interface for the versions component
of the Scotty library. It pulls together the version Fetcher, Checker, and an NeDB
to provide several methods that comprise complete operations

    class exports.manager


Version Fetcher, Checker instances
----------------------------------------
An instance of each of the other versions classes is attached to the Manager
on initialization

* *Fetcher* - talks to github to retrieve available version lists and download versions.
* *Checker* - used for checking semver information and determining which version is most recent.




Initialization
--------------

        constructor: (@options = {})->

A new instance of the Github api, provided by [node-github](http://npmjs.org/package/github) is
initialized, to be used by the Fetcher instance.


        boot: ()->
            # Todo: remove this. It's just for testing-ish stuff
            if not @api
                @api = new github
                    version: "3.0.0",
                    debug: @options.debug ? false,
                    protocol: "https",

            @checker = new checker
            @fetcher = new fetcher @api, @checker

An NeDB which maintains the **versions.db** file, to track version data is also initialized.

            @_versiondb = new nedb
                filename: @options.version_file
                autoload: @options.autoload

            @versions = new storage @_versiondb, @checker


Retrieving Version data
-----------------------

        fetch: (callback)->

Using the Fetcher instance, Manager communicates with Github and retrieves the list
of available phaser engine versions.

            @fetcher.fetchVersions (versions)=>

Once the version list request returns, the `@versions` storage object is updated

                @versions.syncVersionList versions, callback




Downloading Versions
--------------------
There are two options for downloading:

`forceDownload` will redownload version, even if it is installed.

        forceDownload: (version, cb)->
            @_download(version, cb)

`download` will only download the requested version if it has not been installed.

        download: (version, callback)->
            @versions.isInstalled version, (exists)=>
                if not exists
                    @_download(version, callback)
                else
                    callback(false)

The download process for both methods is handled in the same way, the only difference being that `download`
triggers a check for version existence before trying to dowload.

        _download: (version, callback)->
            @versions.get version, (err, ver)=>
                return callback(false) if not ver

                request = @fetcher.download version, ver.url, @options.phaser_path, ()=>
                    @versions.install(version, callback)


Setters
-------
Methods for externally setting Checker, File, and Fetcher instances

        setChecker: (checker)->
            @checker = check


        setFile: (local)->
            @file = local


        setFetcher: (fetcher)->
            @fetcher = fetcher


        setDb: (db)->
            @_versiondb = db
            @versions.db = db

        setApi: (api)->
            @api = api
