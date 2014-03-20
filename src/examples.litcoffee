    request = require('request')
    zlib = require('zlib')
    tar = require('tar')
    fs = require('fs-extra')

Examples
========
Little class for handling code for fetching phaser example repository

    class exports.examples

        constructor: (@options)->


        installed: ()->
            return fs.existsSync(@options.examples_path)


        download: (on_complete = ->)->
            dest = @options.examples_path
            fs.removeSync(dest)

            url = @getDownloadUrl()

            options = { headers: { "User-Agent": 'test/1.0' } }

            req = request(url, options)
            req.pipe(zlib.createGunzip())
                .pipe(tar.Extract({ path: "#{dest}", strip: 1}));

            req.on 'end', ()=>
                on_complete()


        # Todo, make configurable?
        getDownloadUrl: ()->
            return "https://github.com/photonstorm/phaser-examples/archive/master.tar.gz"
