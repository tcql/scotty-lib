chai = require('chai')
chai.should()

{fileutil} = require "../src/fileutil"


describe 'fileutil Instance', ->

    it 'should be instantiable', ->
        f = new fileutil


    it 'should read the datafile', ->
        f = new fileutil './test/data/fileutil.json'

        f.read()
        f.getData().should.eql {"fake": "data", "fake2": "other"}


    it 'should not re-read the datafile if data is already populated', ->
        f = new fileutil './test/data/fileutil.json'

        f.setData({"a": "b"})
        f.read()
        f.getData().should.eql {"a": "b"}


    it 'should re-read the datafile if it is forced', ->
        f = new fileutil './test/data/fileutil.json'

        f.setData({"a": "b"})
        f.read(true)
        f.getData().should.eql {"fake": "data", "fake2": "other"}



    it 'can read sub-properties of the filedata', ->
        f = new fileutil
        f.setData({"a": "b", "c": "d"})

        f.get("a").should.equal "b"


    it 'can set sub-properties of the filedata', ->
        f = new fileutil
        f.setData({"a": "b", "c": "d"})

        f.set("a", "e")

        f.get("a").should.equal "e"


    it 'can set the filedata', ->
        f = new fileutil
        data = {"a": "b", "c": "d"}
        f.setData data
        f.getData().should.equal data
