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
        data = project.getMetadata()

        if @projectExists(data.name)
            throw Error("A Project named #{data.name} already exists")

        @filedata.projects.push project.getMetadata()
        @writeFile()


    removeProject: (name)->
        @readFile()

        ind = @getProjectIndex(name)
        if ind is false
            throw Error("Cannot delete project that does not exist")

        @filedata.projects.splice(ind, 1)

        @writeFile()


    getProjectIndex: (name)->
        @readFile()
        for p,i in @filedata.projects
            return i if name is p.name

        return false

    getProject: (name)->
        ind = @getProjectIndex(name)

        if ind isnt false
            return @filedata.projects[ind]

        return false


    updateProject: (project)->
        meta = project.getMetadata()
        ind = @getProjectIndex(meta.name)

        @filedata.projects[ind] = project.getMetadata()

        @writeFile()



    projectExists: (name)->
        if @getProjectIndex(name) isnt false
            return true

        return false

