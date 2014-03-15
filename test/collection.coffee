chai = require('chai')
chai.should()

{collection} = require '../src/collection'

describe 'Collection Instance', ->

    it 'should be instantiable', ->
        c = new collection


    it 'should accept a list', ->
        c = new collection ["A", "C"]
        c.getCollection().should.eql ["A", "C"]


    it 'can set an arbitrary list', ->
        c = new collection
        c.setCollection(["1", "5", "R"])
        c.getCollection().should.eql ["1", "5", "R"]


    it 'can retrieve a value by attribute', ->
        c = new collection
        c.setCollection [{name: "0.1.1", url: "fake"}, {name: "1.0.0", url: "beep"}]

        c.get("name", "1.0.0").should.eql {name: "1.0.0", url: "beep"}
        c.get("url", "fake").should.eql {name: "0.1.1", url: "fake"}


    it 'can retrieve a value by index', ->
        c = new collection [{name: "hi"}, {name: "beep"}]
        c.getAt(0).should.eql {name: "hi"}


    it 'can remove an item from the list', ->
        c = new collection ["A", "C"]
        c.remove("A")
        c.getCollection().should.eql ["C"]


    it 'can remove an item by index', ->
        c = new collection ["H","e", "l", "l", "o"]
        c.removeAt(0)
        c.getCollection().should.eql ["e", "l", "l", "o"]




