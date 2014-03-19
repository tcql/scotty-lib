fs = require('fs-extra')
path = require('path')

class exports.project
    constructor: (@paths)->

    createOnDiskByCopy:  (project, template)->
        location = project.path
        location = path.resolve(location)

        if fs.existsSync(template)
            fs.copySync(template, location)
            project.path = location

            return true

        return false



    createOnDisk: (project)->
        location = project.path
        location = path.resolve(location)

        if not fs.existsSync(location)
            fs.mkdirSync(location)
            location.path = location

            return true

        return false


    moveOnDisk: (original, project)->
        location = path.resolve(project.path)
        fs.removeSync(location)

        if fs.existsSync(original.path)
            res = fs.renameSync original.path, location
            return true

        return false


    installPhaser: (project, version = null)->
        version = version ? project.phaser_version
        phaser = "#{@paths.phaser_path}/#{version}"

        phaser_dest = project.phaser_path ? project.path+"/phaser"

        if fs.existsSync(phaser)
            fs.copySync(phaser, phaser_dest)
            project.phaser_path = phaser_dest
            return true

        return false


    uninstallPhaser: (project)->
        fs.removeSync(project.phaser_path)



    deleteOnDisk: (project)->
        if fs.existsSync(project.path)
            fs.removeSync(project.path)
            return true

        return false
