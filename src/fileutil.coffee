fs = require 'fs-extra'

###
 * Exists as a base class to be used by other
 * components of scotty
###
class exports.fileutil

    constructor: (@filepath)->


    read: (force = false)->
        if not fs.existsSync(@filepath)
            @write()

        if force or not @filedata
            @filedata = fs.readJsonSync(@filepath)

        return @filedata


    get: (property)->
        return @filedata[property]


    set: (property, value)->
        @filedata[property] = value


    appendTo: (property, value)->
        if not @filedata[property]?
            @filedata[property] = []

        @filedata[property].push value


    write: ()->
        if not @filedata
            @setInitialFileData()

        fs.outputJsonSync(@filepath, @filedata)

    getData: ()->
        return @filedata


    setData: (data)->
        @filedata = data

    ###
     * setInitialFileData() -> null
     *
     * Sets the default data for a newly instantiated file
    ###
    setInitialFileData: ()->
        @filedata = {}
