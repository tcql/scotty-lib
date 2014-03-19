fs = require 'fs-extra'
nedb = require 'nedb'
chai = require 'chai'
chai.should()

{manager} = require '../src/versions/manager'

describe 'Version manager Instance', ->

    it 'should be instantiable', ->
        m = new manager {}


    # This is an integration test; it actually hits github
    it 'should fetch versions from github and write to the neDB', ->
        m = new manager {}
        m.boot()

        # use a non-file based DB
        db = new nedb
        m.setDb db

        m.fetch (versions)=>
            db.count {}, (err, ct)->
                ct.should.equal versions.length


    it 'should not download if version exists during `download`', ->
        m = new manager {}
        m.versions =
            isInstalled: (version, callback)->
                # Version already exists
                callback true

        called = false
        m._download = ()->
            called = true

        m.download '1.2.3', (result)->
            result.should.equal false

            # double check _download wasn't called
            called.should.equal false


    it 'should download if version exists during `download`', ->
        m = new manager {}
        m.versions =
            isInstalled: (version, callback)->
                # Version doesn't exist
                callback false

        called = false
        m._download = ()->
            called = true

        m.download '1.2.3', (result)->
            result.should.equal true

            # double check _download wasn't called
            called.should.equal true

