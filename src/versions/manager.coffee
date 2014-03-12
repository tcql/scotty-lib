fetcher = require('./fetcher').fetcher
checker = require('./checker').checker
local = require('./file').file

github = require('github')

# Tie together versions components.
# Will allow downloading versions (via fetcher),
# And will be where we handle storing what versions we have installed.


class exports.manager

    constructor: (@options)->
        api = new github
            version: "3.0.0",
            debug: @options.debug ? false,
            protocol: "https",

        @checker = new checker
        @fetcher = new fetcher api, @checker
        @local = new local @options.version_file


    setChecker: (checker)->
        @checker = check


    setLocalFile: (local)->
        @local = local


    setFetcher: (fetcher)->
        @fetcher = fetcher


    downloadLatestVersionIfNecessary: (cb)->
        @checker.setLatestInstalled(@local.getLatestInstalled())

        @fetcher.fetchLatestVersion (fetch, version)=>
            @checker.setLatest(version)

            if not @checker.isLatestInstalled()
                @fetcher.downloadVersion version, ()=>
                    @local.setLatestInstalled(version)
                    @local.addInstalled(version)
                    cb(true)
            else
                cb(false)


    getActualInstalledVersion: ()->
