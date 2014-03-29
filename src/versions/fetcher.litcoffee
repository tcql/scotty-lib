
    request = require('request')
    zlib = require('zlib')
    tar = require('tar')
    progress = require('request-progress')

Version Fetcher
===============
Fetcher is a class for fetching version tags and phaser tarballs from the phaser
github.

    class exports.fetcher

Fetcher uses the Github api class provided by [node-github](http://npmjs.org/package/github)

        constructor: (@api)->


Getting available versions
--------------------------
Fetcher is primarily used for fetching information about phaser releases from the Github API.
The data returned contains version names and tarball urls

        fetchVersions: (cb = ->)->
            @api.repos.getTags
                user: "photonstorm"
                repo: "phaser",
                (err, versions)=>
                    for version in versions
                       version.url = "https://github.com/photonstorm/phaser/archive/#{version.name}.tar.gz"

                    cb(versions)


Downloading a phaser version
----------------------------
Fetcher can be used to download and extract a phaser version from github
by providing a `version`, a `url` (for the tarball), a `destination`, and an `on_complete` callback.
Versions are automatically unzipped

        download: (version, url, destination, on_progress, on_complete) ->
            on_complete = on_complete ? ()->
            on_progress = on_progress ? ()->

            options = {}

            req = progress(request(url, options))
                .on 'progress', on_progress
                .on 'end', ()=>
                    on_complete("#{destination}/#{version}")
                .pipe(zlib.createGunzip())
                .pipe(tar.Extract({ path: "#{destination}/#{version}", strip: 1}));


            return req


