fs = require('fs-extra')
path = require('path')

class exports.project

    constructor: (@metadata = {}, @paths)->



    getMetadata: ()->
        return @metadata


    createOnDiskByCopy:  (location = null, template)->
        location = location ? @metadata.path
        location = path.resolve(location)

        if fs.existsSync(template)
            fs.copySync(template, location)
            @metadata.path = location

            return true

        return false



    createOnDisk: (location = null)->
        location = location ? @metadata.path

        location = path.resolve(location)

        if not fs.existsSync(location)
            fs.mkdirSync(location)
            @metadata.path = location

            return true

        return false


    moveOnDisk: (location)->
        location = path.resolve(location)

        if fs.existsSync(@metadata.path) and not fs.existsSync(location)
            fs.renameSync(@metadata.path, location)
            @metadata.path = location

            return true

        return false


    installPhaser: (version = null)->
        version = version ? @metadata.phaser_version
        phaser = "#{@paths.phaser_path}/#{version}"

        if fs.existsSync(phaser)
            fs.copySync(phaser, @getPhaserDestination())
            return true

        return false


    getPhaserDestination: ()->
        if not @metadata.phaser_path
            @metadata.phaser_path = @metadata.path+"/phaser"

        return @metadata.phaser_path


    deleteOnDisk: ()->
        if fs.existsSync(@metadata.path)
            fs.removeSync(@metadata.path)
            return true

        return false
