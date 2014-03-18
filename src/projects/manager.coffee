{project} = require './project'
{storage} = require './storage'
nedb = require 'nedb'

class exports.manager

    constructor: (@options)->

    boot: ()=>
        @_projectdb = new nedb
            filename: @options.project_file
            autoload: @options.autoload

        @_project_files = new project @options
        @projects = new storage @_projectdb


    createProject: (project, options, callback = ->)->
        @projects.nameInUse options.name, (exists)=>
            if exists
                return callback("A project with that name already exists")

                @_project_files.createOnDisk project
                @projects.add project, callback



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
