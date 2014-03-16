chai = require('chai')
chai.should()

{manager} = require '../src/versions/manager'

describe 'Version manager Instance', ->

    it 'should be instantiable', ->
        m = new manager {}


    it 'should fetch version lists and update the version file', ->
        m = new manager {}

        called = false

        # Disable this method so we can test that separately later
        m._updateAvailableInFile = ()->

        fetched_versions = [
            {name: "1.0.0", url: "abcd"}
            {name: "1.2.0", url: "efgh"}
        ]

        ###
         * Available versions collection that will be
         * called after the versions are fetched
        ###
        m.available =
            setCollection: (versions)->
                versions.should.eql fetched_versions


        # Mock the Fetcher
        m.setFetcher
            fetchVersions: (cb)->
                cb(fetched_versions)

        m.fetch (available)->
            called = true
            m.available.should.eql available

        # sanity test to make sure the
        # callback actually got called
        called.should.equal true


