semver = require('semver')

# request = require('request')
# zip     = require('adm-zip')

class exports.fetcher

    # Takes instance of GitHubApi (from npmjs.org/package/github)
    constructor: (@api, @checker)->
        @available_versions = []
        @raw_versions = []


    ###
     * fetchVersions(callback) -> null
     *     - cb (function): callback with this as first argument and version list as the second argument
     *
     *  Fetches available versions from github api
    ###
    fetchVersions: (cb = ->)->
        @api.repos.getTags
            user: "photonstorm"
            repo: "phaser",
            (err, versions)=>
                @raw_versions = versions
                versions = versions.map (elem)->
                    return elem.name

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
     * getRawVersions() -> Array
     *
     * Returns cached raw version data
    ###
    getRawVersions: ()->
        return @raw_versions

    ###
     * getUrlForVersion(version) -> String
     *     - version(String): zipball url for the given version
     *
     * Retrieves the url for the given version's zipball.
     * Throws an error if no version matches
    ###
    getUrlForVersion: (version)->
        versions = @getRawVersions().filter (elem)=>
            return @checker.cleanVersion(elem.name) is @checker.cleanVersion(version)

        if versions.length is 0
            throw Error("No such version")

        return versions[0].zipball_url

    ###
     * setVersions(versions) -> null
     *     - versions(Array): versions to be set
     *
     * Sets @available_versions to the versions parameter
    ###
    setVersions: (versions)->
        @available_versions = versions

    ###
     * getLatest() -> string
     *
     * Returns the latest version available for download
    ###
    getLatest: ()->
        if @available_versions.length is 0
            throw Error("Versions must be fetched before checking latest version")

        return @checker.getLatest(@available_versions)


    download: (version, on_complete = ->)->
        url = @getUrlForVersion(version)


        # url     = 'https://github.com/photonstorm/phaser/archive/'+version+'.zip'
        # file    = base.getTempPath()+'/'+version+".zip"
        # dest    = base.getEnginePath()

        # req     = request(url)
        # req.pipe(fs.createWriteStream(file))

        # req.on 'end', ()=>
        #     on_complete()

        # return req

