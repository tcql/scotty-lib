{fetcher} = require('./fetcher')
{checker} = require('./checker')
{file} = require('./file')
{collection} = require("../collection")

github = require('github')

# Tie together versions components.
# Will allow downloading versions (via fetcher),
# And will be where we handle storing what versions we have installed.


class exports.manager

    constructor: (@options = {})->
        api = new github
            version: "3.0.0",
            debug: @options.debug ? false,
            protocol: "https",

        @checker = new checker
        @fetcher = new fetcher api, @checker
        @file   = new file(@options.version_file)

        @initializeCollections()


    initializeCollections: ()->
        @file.read()

        @installed = new collection @file.get("installed")
        @available = new collection @file.get("available")


    setChecker: (checker)->
        @checker = check


    setFile: (local)->
        @file = local


    setFetcher: (fetcher)->
        @fetcher = fetcher


    fetch: (cb)->
        @fetcher.fetchVersions (fetcher, versions)=>
            @available.setCollection(versions)

            file_vers = @available.map (elem)->
                return {name: elem.name, url: elem.url}

            @file.set("available", file_vers.getCollection())
            @file.write()

            cb(@available)


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


