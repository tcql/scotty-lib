semver = require('semver')
request = require('request')
fs = require('fs')
zlib = require('zlib')
tar = require('tar')

class exports.fetcher

    # Takes instance of GitHubApi (from npmjs.org/package/github)
    constructor: (@api)->


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
                cb(@, versions)


    ###
     * download(version, destination, on_complete) -> request
     *     - version (String): version to download
     *     - destination (String): path to extract
     *     - on_complete (Function): callback to run once tar has been downloaded
     *
    ###
    download: (version, url, destination, on_complete = ->)->
        #url = @getUrlForVersion(version)
        options = { headers: { "User-Agent": 'test/1.0' } }

        req = request(url, options)
        req.pipe(zlib.createGunzip())
            .pipe(tar.Extract({ path: "#{destination}/#{version}", strip: 1}));

        req.on 'end', ()=>
            on_complete("#{destination}/#{version}")

        return req


