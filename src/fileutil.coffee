fs = require 'fs-extra'

###
 * Exists as a base class to be used by other
 * components of scotty
###
class exports.fileutil


    readFile: (force = false)->
        if not fs.existsSync(@filepath)
            @writeFile()

        if force or not @filedata
            @filedata = fs.readJsonSync(@filepath)

        return @filedata


    writeFile: ()->
        if not @filedata
            @setInitialFileData()

        fs.outputJsonSync(@filepath, @filedata)


    ###
     * setInitialFileData() -> null
     *
     * Sets the default data for a newly instantiated file
    ###
    setInitialFileData: ()->
        @filedata = {}
