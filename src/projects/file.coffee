fileutil = require('../utils/file').file

class exports.file extends fileutil

    constructor: (@filepath)->

    getProjectNames: ()->
        @read()

        projects = []
        for p in @filedata.projects
            projects.push p.name

        return projects


    setInitialFileData: ()->
        @filedata = {projects: []}


    addProject: (project)->
        @read()
        data = project.getMetadata()

        @filedata.projects.push data
        @write()


    removeProject: (name)->
        @read()

        ind = @getProjectIndex(name)
        if ind is false
            throw Error("Cannot delete project that does not exist")

        @filedata.projects.splice(ind, 1)

        @write()


    getProjectIndex: (name)->
        @read()
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

        @write()



    projectExists: (name)->
        if @getProjectIndex(name) isnt false
            return true

        return false

