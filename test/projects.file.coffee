chai = require('chai')
chai.should()

{file} = require '../src/projects/file'

describe 'Project file Instance', ->

    it 'should be instantiable', ->
        f = new file

    it 'can return project names', ->
        f = new file

        f.readFile = ->
        f.writeFile = ->
        f.setInitialFileData()

        f.filedata.projects.push
            name: "Project 1"

        f.filedata.projects.push
            name: "Project 2"

        f.getProjectNames().should.eql ["Project 1", "Project 2"]

    it 'can add a project', ->
        f = new file

        f.readFile = ->
        f.writeFile = ->
        f.setInitialFileData()

        project =
            getMetadata: ()->
                return {name: "project 1", version: "1.1.6"}

        f.addProject(project)
        f.filedata.projects.should.eql [{name: "project 1", version: "1.1.6"}]


    it 'will throw an error if you try adding a project whose name is already in use', ->
        f = new file
        f.readFile = ->
        f.writeFile = ->
        f.setInitialFileData()

        project =
            getMetadata: ()->
                return {name: "project 1", version: "1.1.6"}

        f.addProject(project)
        (-> f.addProject(project)).should.throw Error


    it 'can remove a project', ->
        f = new file
        f.readFile = ->
        f.writeFile = ->
        f.setInitialFileData()

        f.filedata.projects.push {name: "project 1"}

        f.removeProject("project 1")

        f.filedata.projects.should.eql []

    it 'will throw an error if you try to remvoe a nonexistant a project', ->
        f = new file
        f.readFile = ->
        f.writeFile = ->
        f.setInitialFileData()

        (-> f.removeProject("project 1")).should.throw Error
