chai = require('chai')
chai.should()

{storage} = require '../src/versions/storage'

describe 'Version storage Instance', ->

    it 'should be instantiable', ->
        s = new storage {}, {}


