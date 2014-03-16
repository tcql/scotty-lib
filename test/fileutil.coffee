chai = require('chai')
chai.should()

{file} = require "../src/utils/file"


describe 'file Instance', ->

    it 'should be instantiable', ->
        f = new file


    it 'should read the datafile', ->
        f = new file './test/data/file.json'

        f.read()
        f.getData().should.eql {"fake": "data", "fake2": "other"}


    it 'should not re-read the datafile if data is already populated', ->
        f = new file './test/data/file.json'

        f.setData({"a": "b"})
        f.read()
        f.getData().should.eql {"a": "b"}


    it 'should re-read the datafile if it is forced', ->
        f = new file './test/data/file.json'

        f.setData({"a": "b"})
        f.read(true)
        f.getData().should.eql {"fake": "data", "fake2": "other"}



    it 'can read sub-properties of the filedata', ->
        f = new file
        f.setData({"a": "b", "c": "d"})

        f.get("a").should.equal "b"


    it 'can set sub-properties of the filedata', ->
        f = new file
        f.setData({"a": "b", "c": "d"})

        f.set("a", "e")

        f.get("a").should.equal "e"


    it 'can set the filedata', ->
        f = new file
        data = {"a": "b", "c": "d"}
        f.setData data
        f.getData().should.equal data
