fs = require('fs-extra')

class exports.project

    constructor: (@metadata = {}, @paths)->



    getMetadata: ()->
        return @metadata


    createOnDiskByCopy:  (location = null, template)->
        location = location ? @metadata.path
        fs.copySync(template, location)
        @metadata.path = location


    createOnDisk: (location = null)->
        location = location ? @metadata.path
        fs.mkdirSync(location)
        @metadata.path = location


    moveOnDisk: (location)->
        fs.renameSync(@metadata.path, location)
        @metadata.path = location


    installPhaser: (version = null)->
        version = version ? @metadata.phaser_version

        phaser = "#{@paths.phaser_path}/#{version}"
        fs.copySync(phaser, @getPhaserDestination())


    getPhaserDestination: ()->
        if not @metadata.phaser_path
            @metadata.phaser_path = @metadata.path+"/phaser"

        return @metadata.phaser_path


    deleteOnDisk: ()->
        fs.removeSync(@metadata.path)
