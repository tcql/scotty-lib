semver = require('semver')

# request = require('request')
# zip     = require('adm-zip')

class exports.fetcher

    # Takes instance of GitHubApi (from npmjs.org/package/github)
    constructor: (@api)->
        @available_versions = []
        @latest_version = null

    ###
     * fetchAvailableVersions(callback) -> null
     *     - cb (function): callback with this as first argument and version list as the second argument
     *
     *  Fetches available versions from github api
    ###
    fetchAvailableVersions: (cb = ->)->
        @api.repos.getTags
            user: "photonstorm"
            repo: "phaser",
            (err, versions)=>
                @setVersions versions
                cb(@, versions)


    ###
     * getVersions() -> Array
     *
     * Returns cached versions
    ###
    getVersions: ()->
        return @available_versions


    ###
     * setVersions(versions) -> null
     *     - versions(Array): versions to be set
     *
     * Sets @available_versions to the versions parameter
    ###
    setVersions: (versions)->
        @available_versions = versions


    ###
     * fetchLatestVersion(callback) -> null
     *     - cb (function): callback with this as the first argument and the latest version as the second argument
     *
     * Fetches the most recent version. If we've cached the version list, don't refetch,
     * just check the cached list. If there isn't a list, fetch it using fetchAvailableVersions
    ###
    fetchLatestVersion: (cb = ->)->
        handleResult = (versions)=>
            @latest_version = semver.maxSatisfying(versions, '>0.0.0')
            cb(@, @latest_version)

        if @available_versions.length is 0
            @fetchAvailableVersions (self, versions)=>
                handleResult(versions)

        else
            handleResult(@available_versions)

    ###
     * getLatestVersion() -> string
     *
     * Returns @latest_version.
    ###
    getLatestVersion: ()->
        return @latest_version



    downloadVersion: (version, on_complete = ->)->
        # url     = 'https://github.com/photonstorm/phaser/archive/'+version+'.zip'
        # file    = base.getTempPath()+'/'+version+".zip"
        # dest    = base.getEnginePath()

        # req     = request(url)
        # req.pipe(fs.createWriteStream(file))

        # req.on 'end', ()=>
        #     on_complete()

        # return req

