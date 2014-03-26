    request = require('request')
    zlib = require('zlib')
    tar = require('tar')
    fs = require('fs-extra')
    progress = require('request-progress')

Examples
========
Little class for handling code for fetching phaser example repository

    class exports.examples

        constructor: (@options)->


        installed: ()->
            return fs.existsSync(@options.examples_path)


        download: (on_complete, on_progress)->
            on_complete = on_complete ? ()->
            on_progress = on_progress ? ()->

            dest = @options.examples_path
            fs.removeSync(dest)

            url = @getDownloadUrl()

            options = { headers: { "User-Agent": 'test/1.0' } }

            req = progress(request(url, options))
                .on 'progress', on_progress
                .on 'end', on_complete
                .pipe(zlib.createGunzip())
                .pipe(tar.Extract({ path: "#{dest}", strip: 1}));


        # Todo, make configurable?
        getDownloadUrl: ()->
            return "https://github.com/photonstorm/phaser-examples/archive/master.tar.gz"
