chai = require('chai')
chai.should()

{fetcher} = require '../src/versions/fetcher'

describe 'Version fetcher Instance', ->

    it 'should be instantiable', ->
        f = new fetcher {}


    it 'should retrieve and return versions list', ->
        version_return = [{name: '1.1.1'}, {name: '1.0.0'}]

        api = repos: getTags: (msg, callback)->
            msg.user.should.equal 'photonstorm'
            msg.repo.should.equal "phaser"
            callback(null, version_return)

        f = new fetcher api

        cb = (versions)->
            versions.should.eql version_return

        f.fetchVersions(cb)


