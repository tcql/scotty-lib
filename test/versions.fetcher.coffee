chai = require('chai')
chai.should()

{fetcher} = require '../src/versions/fetcher'

describe 'Version fetcher Instance', ->

    it 'should be instantiable', ->
        f = new fetcher {}


    it 'should retrieve and return versions list', ->
        api = repos: getTags: (msg, callback)->
            msg.user.should.equal 'photonstorm'
            msg.repo.should.equal "phaser"
            callback(null, [{name: '1.1.1'}, {name: '1.0.0'}])

        f = new fetcher api

        cb = (fetcher, versions)->
            f.available_versions.should.eql ['1.1.1', '1.0.0']

        f.fetchVersions(cb)


    it 'should return url for a given version', ->
        f = new fetcher {},
            cleanVersion: (elem)-> elem

        f.raw_versions = [
            name: '1.1.6'
            tarball_url: 'this is a url!'
        ]

        f.getUrlForVersion('1.1.6').should.equal 'this is a url!'


    it "should throw an error when getting url for a version that doesn't exist", ->
        f = new fetcher {},
            cleanVersion: (elem)-> elem

        (-> f.getUrlForVersion('1.1.6')).should.throw Error


    it 'should get latest version', ->
        f = new fetcher {},
            getLatest: (versions)->
                versions.should.eql ['1.0.0', '1.1']
                return '1.1'
        f.available_versions = ['1.0.0', '1.1']

        f.getLatest().should.equal '1.1'
