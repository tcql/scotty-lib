fs = require 'fs'
jsonfile = require 'jsonfile'

class exports.fileutil


    readFile: (force = false)->
        if not fs.existsSync(@filepath)
            @writeFile()

        if force or not @filedata
            @filedata = jsonfile.readFileSync(@filepath)

        return @filedata


    writeFile: ()->
        if not @filedata
            @filedata =
                latest: '',
                installed: []

        jsonfile.writeFileSync(@filepath, @filedata)

