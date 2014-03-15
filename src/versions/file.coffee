fileutil = require('../fileutil').fileutil


class exports.file extends fileutil

    constructor: (@filepath)->

    isInstalled: (version)->
        @read()

        if version in @filedata.installed
            return true

        return false


    setInitialFileData: ()->
        @filedata =
            latest: ""
            installed: []
            available: []
