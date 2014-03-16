{file} = require('./file')
{project} = require('./project')

class exports.manager

    constructor: (@options)->

    boot: ()->
        @file = new file(@options.project_file)




    createProject: (options)->
        if @file.projectExists(options.name)
            return false

        p = new project(options, @options)

        if p.createOnDisk()
            p.installPhaser()
            @file.addProject(p)

        return p


    getProjects: ()->
        projects = []
        for project in @file.get("projects")
            projects.push(new project(project, @options))

        return projects



    moveProject: (name, dest)->
        proj = @getProject(name)

        if not proj
            throw Error("Cannot move project #{name}; it does not exist")

        if proj.moveOnDisk(dest)
            @file.updateProject(proj)


    getProject: (name)->
        opts = @file.getProject(name)

        if opts
            return new project(opts, @options)


    deleteProject: (name)->
        project = @getProject(name)

        if project.deleteOnDisk()
            @file.removeProject(name)
