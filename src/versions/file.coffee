jsonfile = require('jsonfile')

class exports.file

    constructor: (@filepath)->



    readFile: (force = false)->
        if force or not @filedata
            @filedata = jsonfile.readFileSync(@filepath)

        return @filedata


    writeFile: ()->
        if not @filedata
            @filedata =
                latest: '',
                installed: []

        jsonfile.writeFileSync(@filepath, @filedata)


    getLatestInstalled: ()->
        return @readFile().latest


    getInstalled: ()->
        return @readFile().installed


    setLatestInstalled: (version)->
        @readFile()
        @filedata.latest = version

        @writeFile()


    addInstalled: (version)->
        @readFile()
        if version not in @filedata.installed
            @filedata.installed.push version

            @writeFile()

