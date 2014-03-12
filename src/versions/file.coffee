fileutil = require('../fileutil').fileutil


class exports.file extends fileutil

    constructor: (@filepath)->


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


    isInstalled: (version)->
        @readFile()

        if version in @filedata.installed
            return true

        return false


    setInitialFileData: ()->
        @filedata =
            latest: ""
            installed: []
