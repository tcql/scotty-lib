semver = require('semver')
request = require('request')
fs = require('fs')
zlib = require('zlib')
tar = require('tar')

class exports.fetcher

    # Takes instance of GitHubApi (from npmjs.org/package/github)
    # and an instance of scotty-lib/src/versions/checker
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

        return versions[0].tarball_url


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


    ###
     * download(version, destination, on_complete) -> request
     *     - version (String): version to download
     *     - destination (String): path to extract
     *     - on_complete (Function): callback to run once tar has been downloaded
     *
    ###
    download: (version, destination, on_complete = ->)->
        url = @getUrlForVersion(version)
        options = { headers: { "User-Agent": 'test/1.0' } }

        req = request(url, options)
        req.pipe(zlib.createGunzip())
            .pipe(tar.Extract({ path: "#{destination}/#{version}", strip: 1}));

        req.on 'end', ()=>
            on_complete("#{destination}/#{version}")

        return req


