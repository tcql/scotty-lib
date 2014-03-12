fileutil = require('../fileutil').fileutil

class exports.file extends fileutil

    constructor: (@filepath)->

    getProjectNames: ()->
        @readFile()

        projects = []
        for p in @filedata.projects
            projects.push p.name

        return projects


    setInitialFileData: ()->
        @filedata = {projects: []}


    addProject: (project)->
        @readFile()
        data = project.metadata()

        if @projectExists(data.name)
            throw Error("A Project named #{data.name} already exists")

        @filedata.projects.push project.metadata()
        @writeFile()


    removeProject: (name)->
        @readFile()

        ind = @getProjectIndex(name)
        if ind is false
            throw Error("Cannot delete project that does not exist")

        @filedata.projects.splice(ind, 1)

        @writeFile()


    getProjectIndex: (name)->
        for p,i in @filedata.projects
            return i if name is p.name

        return false


    projectExists: (name)->
        if @getProjectIndex(name) isnt false
            return true

        return false

