chai = require('chai')
chai.should()

{file} = require '../src/versions/file'
fs = require 'fs-extra'


describe 'Version file Instance', ->

    it 'should be instantiable', ->
        f = new file {}

    it 'should write empty versions file', ->
        v = './test/data/empty_versions.json'

        f = new file v
        f.write()

        fs.readJsonSync(v).should.eql {latest: '', installed: [], available: []}

        fs.unlinkSync v

    it 'should confirm when version is installed', ->
        f = new file
        f.read = ()->
        f.filedata = {installed: ["1.0.1"]}

        f.isInstalled('1.0.1').should.eql true
        f.isInstalled('2.0.0').should.eql false
