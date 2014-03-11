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
            callback(null, ['1.1.1', '1.0.0'])

        f = new fetcher api

        cb = (fetcher, versions)->
            f.available_versions.should.eql ['1.1.1', '1.0.0']

        f.fetchAvailableVersions(cb)


    it 'should retrieve and return latest version', ->
        f = new fetcher {}
        f.fetchAvailableVersions = (cb)->
            cb(f,['1.5.0','1.6.0'])

        cb = (fetcher, version)->
            version.should.equal '1.6.0'

        f.fetchLatestVersion(cb)


    it 'should return latest version from cache', ->
        f = new fetcher {}
        f.setVersions(['1.0.0', '1.2.0'])

        cb = (fetcher, version)->
            version.should.equal '1.2.0'

        f.fetchLatestVersion(cb)

    # todo
    it 'can download versions', ->
        f = new fetcher {}
        f.should.equal false
