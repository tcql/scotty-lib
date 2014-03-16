chai = require('chai')
should = chai.should()

{collection} = require '../src/utils/collection'

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


    it 'can filter a collection', ->
        c = new collection ["a", "aa", "b", "bb"]
        result = c.filter (elem)->
            return elem is "a"

        result.getCollection().should.eql ["a"]


    it 'should create a new collection when using map', ->
        orig = [1..5]
        c = new collection orig

        c2 = c.map (elem)->
            return elem*2

        c2.getCollection().should.eql [2,4,6,8,10]
        c.getCollection().should.eql orig


    it 'should modify the collection when using transform', ->
        orig = [1..5]
        c = new collection orig

        c.transform (elem)->
            return elem*2

        c.getCollection().should.eql [2,4,6,8,10]


    it 'can add a single item to the collection', ->
        c = new collection

        c.add({"name": "Fred"})

        c.getCollection().should.eql [{"name": "Fred"}]


    it 'should return null when getting items that dont exist', ->
        c = new collection

        should.equal c.get("name", "fake"), null
        should.equal c.getAt(0), null
