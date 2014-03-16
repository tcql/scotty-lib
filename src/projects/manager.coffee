{file} = require './file'
{project} = require './project'
{collection} = require '../utils/collection'

class exports.manager

    constructor: (@options)->

    boot: ()->
        @file = new file(@options.project_file)

        @file.read()

        # initialize project collection
        @projects = new collection @file.get("projects")
        @projects.transform (elem)=>
            return new project(elem, @options)




    createProject: (options)->
        if @projects.get("name", options.name)
            return false

        p = new project(options, @options)

        if p.createOnDisk()
            p.installPhaser()
            @projects.add(p)
            @file.addProject(p)

        return p


    moveProject: (name, dest)->
        proj = @projects.get("name", name)

        if not proj
            throw Error("Cannot move project #{name}; it does not exist")

        if proj.moveOnDisk(dest)
            @file.updateProject(proj)


    deleteProject: (name)->
        project = @projects.get("name", name)

        if project.deleteOnDisk()
            @projects.remove(project)
            @file.removeProject(name)
