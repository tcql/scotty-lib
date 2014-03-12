{file} = require('./file')
{project} = require('./project')

class exports.manager

    constructor: (@options)->
        @file = new file(@options.project_file)


    createProject: (options)->
        if @file.projectExists(options.name)
            return false

        p = new project(options, @options)
        p.createOnDisk()
        p.installPhaser()
        @file.addProject(p)

        return p


    moveProject: (name, dest)->
        proj = @getProject(name)

        if not proj
            throw Error("Cannot move project #{name}; it does not exist")

        proj.moveOnDisk(dest)
        @file.updateProject(proj)


    getProject: (name)->
        opts = @file.getProject(name)

        if opts
            return new project(opts, @options)


    deleteProject: (name)->
        project = @getProject(name)

        @file.removeProject(name)
        project.deleteOnDisk()
