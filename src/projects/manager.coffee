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


    create: (project, options, callback = ->)->
        @projects.nameInUse project.name, (exists)=>
            callback(["A project with that name already exists"], null) if exists

            @_project_files.createOnDisk project
            @_project_files.installPhaser project

            @projects.add project, callback


    update: (id, project, callback = ->)->
        @projects.getById id, (err, old)=>
            callback(err, null) if err

            if old.path != project.path
                @_project_files.moveOnDisk old, project

            @projects.update project, callback


    delete: (id, callback = ->)->
        @projects.getById id, (err, project)=>
            callback(err, null) if err

            @projects.deleteById id, (err, numDel)=>
                callback(err, null) if err

                if numDel > 0
                    @_project_files.deleteOnDisk project

                callback(null, project)
