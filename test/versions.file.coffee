chai = require('chai')
chai.should()

{file} = require '../src/versions/file'

describe 'Version file Instance', ->

    it 'should be instantiable', ->
        f = new file {}

    it 'should read versions from json', ->

