    {fetcher} = require('./fetcher')
    {checker} = require('./checker')
    {file} = require('./file')
    {collection} = require("../collection")

    github = require('github')

Version Manager
===============
The version Manager class is the externally exposed interface for the versions component
of the Scotty library. It pulls together the version Fetcher, Checker, and File classes
to provide several methods that comprise complete operations.

    class exports.manager


Version Fetcher, Checker, File instances
----------------------------------------
An instance of each of the other versions classes is attached to the Manager
on initialization

* *Fetcher* - talks to github to retrieve available version lists and download versions.
* *Checker* - used for checking semver information and determining which version is most recent.
* *File* - used for reading/persisting data to the scotty **versions.json** metadata file.



Initialization
--------------

        constructor: (@options = {})->

A new instance of the Github api, provided by [node-github](http://npmjs.org/package/github) is
initialized, to be used by the Fetcher instance.

            api = new github
                version: "3.0.0",
                debug: @options.debug ? false,
                protocol: "https",

            @checker = new checker
            @fetcher = new fetcher api, @checker
            @file   = new file(@options.version_file)

Once the Checker, Fetcher, and File instances have been booted up, several Scotty collections are
created to make dealing with version lists simpler.

            @initializeCollections()


        initializeCollections: ()->

The collections created are `@installed` (all installed versions) and `@available` (all versions available for download).
They are pre-populated by reading the File instance.

            @file.read()

            @installed = new collection @file.get("installed")
            @available = new collection @file.get("available")


Retrieving Version data
-----------------------

        fetch: (cb)->

Using the Fetcher instance, Manager communicates with Github and retrieves the list
of available phaser engine versions.

            @fetcher.fetchVersions (fetcher, versions)=>

Once the version list request returns, Manager uses the version data to populate the `@available` collection.

                @available.setCollection(versions)

The version list is also reformatted and written out to the File instance so we can easily get cached version data
without re-contacting Github every time we need an available versions list.

                file_vers = @available.map (elem)->
                    return {name: elem.name, url: elem.url}

                @file.set("available", file_vers.getCollection())
                @file.write()

                cb(@available)


Downloading Versions
--------------------


        forceDownload: (version, cb)->
            @_download(version, true, cb)


        download: (version, cb)->
            @_download(version, false, cb)



        getVersionData: ()->
            return @available.map (elem)=>
                try
                    item = @installed.get("name", elem.name)
                    installed = true
                catch error
                    installed = false

                return {name: elem.name, installed: installed}


        _checkExisting: (version)->
            try
                existing = @installed.get("name", version)
                return true
            catch error
                return false


        _download: (version, force, cb)->
            item = @available.get("name", version)
            url = item.url

            exists = @_checkExisting(version)

            if exists and not force
                return

            request = @fetcher.download version, url, @options.phaser_path, ()=>
                return @_afterDownload(exists, version, cb)


        _afterDownload: (exists, version, cb)=>
            if not exists
                @installed.add version
                @file.set("installed", @installed.getCollection())

            if @checker.isLatest(version, @installed.getCollection())
                @file.set("latest", version)

            @file.write()

            cb(version)


        setChecker: (checker)->
            @checker = check


        setFile: (local)->
            @file = local


        setFetcher: (fetcher)->
            @fetcher = fetcher
